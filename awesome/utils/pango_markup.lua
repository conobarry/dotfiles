
local pango_markup = {
  font_desc = nil,
  font_family = nil,
  face = nil,
  size = nil,
  style = nil,
  weight = nil,
  variant = nil,
  stretch = nil,
  foreground = nil,
  background = nil,
  underline = nil,
  rise = nil,
  strikethrough = nil,
  fallback = nil,
  lang = nil,
}

local attributes = {
  "font_desc", -- A font description string, such as "Sans Italic 12"; note that any other span attributes will override this description. So if you have "Sans Italic" and also a style="normal" attribute, you will get Sans normal, not italic.
  "font_family", -- A font family name such as "normal", "sans", "serif" or "monospace".
  "face", -- A synonym for font_family
  "size", -- The font size in thousandths of a point, or one of the absolute sizes 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large', or one of the relative sizes 'smaller' or 'larger'.
  "style", -- The slant style - one of 'normal', 'oblique', or 'italic'
  "weight", -- The font weight - one of 'ultralight', 'light', 'normal', 'bold', 'ultrabold', 'heavy', or a numeric weight.
  "variant", -- The font variant - either 'normal' or 'smallcaps'.
  "stretch", -- The font width - one of 'ultracondensed', 'extracondensed', 'condensed', 'semicondensed', 'normal', 'semiexpanded', 'expanded', 'extraexpanded', 'ultraexpanded'.
  "foreground", -- An RGB color specification such as '#00FF00' or a color name such as 'red'.
  "background", -- An RGB color specification such as '#00FF00' or a color name such as 'red'.
  "underline", -- The underline style - one of 'single', 'double', 'low', or 'none'.
  "rise", -- The vertical displacement from the baseline, in ten thousandths of an em. Can be negative for subscript, positive for superscript.
  "strikethrough", -- 'true' or 'false' whether to strike through the text.
  "fallback", -- If True enable fallback to other fonts of characters are missing from the current font. If disabled, then characters will only be used from the closest matching font on the system. No fallback will be done to other fonts on the system that might contain the characters in the text. Fallback is enabled by default. Most applications should not disable fallback.
  "lang", -- A language code, indicating the text language.
}

function pango_markup:generate()

  self.text = self.text or ""

  local markup_text = "<span"

  --print(self.color)

  for _, value in pairs(attributes) do
    --print(value)
    if self[value] then
      markup_text = string.format("%s %s='%s'", markup_text, value, self[value])
    end
  end

  markup_text = string.format("%s>%s</span>", markup_text, self.text)

  return markup_text

end

function pango_markup:new(args)

  local markup = {
    generate = pango_markup.generate,
    text = args.text or ""
  }

  setmetatable(markup, pango_markup)

  for _, attr in pairs(attributes) do
    if args[attr] then
      markup[attr] = args[attr]
    end
  end

  return markup

end

function pango_markup:__tostring()
  return pango_markup:generate()
end

return setmetatable(pango_markup, {
  __call = function(_, ...) return pango_markup:new(...) end
})