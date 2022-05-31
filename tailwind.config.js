module.exports = {
	content: [
		"./app/helpers/**/*.rb",
		"./app/javascript/**/*.js",
		"./app/views/**/*",
	],
	theme: {
		colors: {
			white: "#ffffff",
			trans: "transparent",
			blue: "#131C31",
			btn: "#38BDF8",
			btnhover: "#1282B4",
			textnormal: "#CBD5E1",
			darky: "#1E293B",
			lighty: "#334155",
			ph: "#4C5B70",
		},
		fontSize: {
			biggest: "3.75rem",
			big: "2.25rem",
			normal: "0.9rem",
			medium: "0.8rem",
			xsmall: "0.7rem",
			small: "1.125rem",
		},
		lineHeight: {
			60: "60px",
		},
		minWidth: {
			basic: "180px",
			medium: "140px",
		},
		width: {
			medium: "140px",
		},
		extend: {
			fontFamily: {
				inter: ["Inter", "sans-serif"],
			},
		},
	},
	plugins: [],
};
