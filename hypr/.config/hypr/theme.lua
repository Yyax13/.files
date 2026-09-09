local palette_path = os.getenv("HOME") .. "/.cache/theme/palette.json"

local function load_palette()
	local f = io.open(palette_path, "r")

	if not f then
		print("[theme] unable to open " .. palette_path)
		return nil
	end

	local data = f:read("*a")
	f:close()

	local palette = {}

	for key, value in data:gmatch('"([^"]+)"%s*:%s*"(#[%x]+)"') do
		palette[key] = value
	end

	return palette
end

local function rgb(hex)
	return "rgb(" .. hex:gsub("#", "") .. ")"
end

local function get(palette, name, fallback)
	return rgb(palette[name] or fallback)
end

local function apply()
	local p = load_palette()

	if not p or not p.primary then
		print("[theme] invalid or missing palette")
		return
	end

	hl.config({
		general = {
			col = {
				active_border = {
					colors = {
						get(p, "primary", "#942124"),
						get(p, "primary_light", "#ffffff"),
						get(p, "primary_dark", "#000000"),
						get(p, "background", "#000000"),
					},
					angle = 45,
				},

				inactive_border = {
					colors = {
						get(p, "foreground_dim", "#707070"),
						get(p, "surface_alt", "#000000"),
						get(p, "background_alt", "#000000"),
						get(p, "background", "#000000"),
					},
					angle = 45,
				},
			},
		},
	})

	print("[theme] applied:", "primary=" .. p.primary, "secondary=" .. (p.secondary or "?"))
end

apply()
