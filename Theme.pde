// Theme
// Color scheme for renderings.

class Theme {
	color fillColor;
	color strokeColor;
	color textColor;

	Theme(color fillColor, color strokeColor, color textColor) {
		this.fillColor = fillColor;
		this.strokeColor = strokeColor;
		this.textColor = textColor;
	}

	color getFillColor() {
		return fillColor;
	}

	color getStrokeColor() {
		return strokeColor;
	}

	color getTextColor() {
		return textColor;
	}
}