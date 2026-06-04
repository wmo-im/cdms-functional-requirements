-- fix-figure-refs.lua
-- Lua filter for pandoc docx output.  Fixes three issues that arise when
-- going AsciiDoc → DocBook → pandoc → docx:
--
-- 1. FIGURE CAPTIONS: pandoc does not auto-number figure captions in docx,
--    so "Figure N. " is prepended to each figure's caption text.
--
-- 2. CROSS-REFERENCES: Asciidoctor drops xrefstyle="short" when emitting
--    DocBook, so <xref linkend="fig_id"/> is resolved by pandoc to the full
--    figure caption.  Internal links whose target is a known figure id are
--    rewritten to "Figure N".
--
-- 3. DOCUMENT STRUCTURE: The AsciiDoc preface (title-page table) arrives in
--    the pandoc AST before the first real chapter heading.  pandoc's --toc
--    flag inserts the TOC *before* all content, so the order becomes
--    TOC → title-page → chapters, which is wrong.  This filter:
--      a. Drops the empty level-1 header emitted for the preface's blank
--         <title> element (the "extraneous heading").
--      b. Injects an OpenXML TOC field — plus surrounding page breaks —
--         immediately before the first real level-1 chapter heading, so the
--         final order is: title-page → TOC → chapters.
--    Because the filter handles the TOC itself, --toc must be omitted from
--    the pandoc command line.

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local PAGE_BREAK = pandoc.RawBlock(
  "openxml",
  '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'
)

-- Word structured-document-tag containing a "dirty" (needs-update) TOC field.
-- When the file is opened in Word (or LibreOffice) the user is prompted to
-- update fields, which populates the TOC with real entries and page numbers.
local TOC_XML = table.concat({
  '<w:sdt>',
  '  <w:sdtPr>',
  '    <w:docPartObj>',
  '      <w:docPartGallery w:val="Table of Contents"/>',
  '      <w:docPartUnique/>',
  '    </w:docPartObj>',
  '  </w:sdtPr>',
  '  <w:sdtContent>',
  '    <w:p>',
  '      <w:pPr><w:pStyle w:val="TOCHeading"/></w:pPr>',
  '      <w:r><w:t xml:space="preserve">Table of Contents</w:t></w:r>',
  '    </w:p>',
  '    <w:p>',
  '      <w:r>',
  '        <w:fldChar w:fldCharType="begin" w:dirty="true"/>',
  '        <w:instrText xml:space="preserve">TOC \\o &quot;1-2&quot; \\h \\z \\u</w:instrText>',
  '        <w:fldChar w:fldCharType="separate"/>',
  '        <w:fldChar w:fldCharType="end"/>',
  '      </w:r>',
  '    </w:p>',
  '  </w:sdtContent>',
  '</w:sdt>',
}, "\n")

local TOC_BLOCK = pandoc.RawBlock("openxml", TOC_XML)

-- ---------------------------------------------------------------------------
-- Main filter (Pandoc-level for two-pass access to the whole document)
-- ---------------------------------------------------------------------------

function Pandoc(doc)

  -- ── Pass 1: number figures and fix their captions ─────────────────────────
  local figure_ids = {}
  local count = 0

  local doc2 = doc:walk({
    Figure = function(fig)
      count = count + 1
      local id = fig.identifier
      if id and id ~= "" then
        figure_ids[id] = count
      end

      -- Prepend "Figure N. " to the first caption block
      if fig.caption and fig.caption.long and #fig.caption.long > 0 then
        local block = fig.caption.long[1]
        if block.t == "Plain" or block.t == "Para" then
          local prefix = {
            pandoc.Str("Figure " .. count .. "."),
            pandoc.Space(),
          }
          for _, inline in ipairs(block.content) do
            table.insert(prefix, inline)
          end
          block.content = prefix
          fig.caption.long[1] = block
        end
      end

      return fig
    end
  })

  -- ── Pass 2: rewrite links that target a figure id ─────────────────────────
  local doc3 = doc2:walk({
    Link = function(link)
      local target = link.target
      if target:sub(1, 1) == "#" then
        local id = target:sub(2)
        local num = figure_ids[id]
        if num then
          link.content = { pandoc.Str("Figure " .. num) }
          return link
        end
      end
    end
  })

  -- ── Pass 3: fix document structure ────────────────────────────────────────
  -- Rebuild the block list:
  --   • Drop any empty level-1 headers (DocBook preface blank <title>).
  --   • Insert PAGE_BREAK + TOC_BLOCK + PAGE_BREAK before the first real
  --     level-1 header (start of the first chapter).
  local new_blocks = {}
  local toc_inserted = false

  for _, block in ipairs(doc3.blocks) do

    -- Drop empty level-1 headers
    if block.t == "Header"
       and block.level == 1
       and #block.content == 0 then
      -- silently skip

    -- Before the first real chapter heading, inject page break + TOC
    elseif block.t == "Header"
           and block.level == 1
           and not toc_inserted then
      table.insert(new_blocks, PAGE_BREAK)
      table.insert(new_blocks, TOC_BLOCK)
      table.insert(new_blocks, PAGE_BREAK)
      toc_inserted = true
      table.insert(new_blocks, block)

    else
      table.insert(new_blocks, block)
    end
  end

  doc3.blocks = new_blocks
  return doc3
end
