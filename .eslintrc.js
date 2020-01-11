module.exports = {

	//TODO: reorder these based on eslint docs

	//"parser": "babel-eslint", // for the <3 of generator comprehensions

	"parserOptions": {
		"ecmaVersion": 2018,
		"sourceType": "module",
		"ecmaFeatures": {
			"impliedStrict": true,
			"jsx": true,
		},
	},

	"env": {
		"browser": true,
		"node": true,
		"es6": true,
		"mocha": true,
	},

	"rules": {

		// Possible Errors
		"comma-dangle": [2, "always-multiline"],
		"valid-jsdoc": 2,

		// Best Practices
		"block-scoped-var": 2,
		"complexity": [2, 15],
		"curly": [2, "multi-line"],
		"default-case": 2,
		"dot-location": [2, "property"],
		"guard-for-in": 2,
		"no-floating-decimal": 2,
		"wrap-iife": 2, //TODO: use "any" instead?

		// Strict Mode
		"strict": [2, "global"],

		// Variables
		// …

		// Node.js
		// …

		// Stylistic Issues
		"brace-style": [2, "1tbs"],
		"camelcase": [2, { "properties": "always" }],
		"quotes": [2, "double", "avoidEscape"],
		"require-jsdoc": 2,

		// ECMAScript 6
		// …

		// Legacy
		"max-depth": [2, 7],
		"max-len": [2, 140],
		"max-params": [2, 11],
		"max-statements": [2, 42],

	},

};
