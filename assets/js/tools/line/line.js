/**
 *                        WHITEBOPHIR
 *********************************************************
 * @licstart  The following is the entire license notice for the
 *  JavaScript code in this page.
 *
 * Copyright (C) 2013  Ophir LOJKINE
 *
 *
 * The JavaScript code in this page is free software: you can
 * redistribute it and/or modify it under the terms of the GNU
 * General Public License (GNU GPL) as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version.  The code is distributed WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU GPL for more details.
 *
 * As additional permission under GNU GPL version 3 section 7, you
 * may distribute non-source (e.g., minimized or compacted) forms of
 * that code without the copy of the GNU GPL normally required by
 * section 4, provided you include this license notice and a URL
 * through which recipients can access the Corresponding Source.
 *
 * @licend
 */

if (window.Tools.boardActivated) {
	(function () { //Code isolation
		//Indicates the id of the line the user is currently drawing or an empty string while the user is not drawing
		var curLineId = "",
			curUpdate = { //The data of the message that will be sent for every new point
				'type': 'update',
				'id': "",
				'x2': 0,
				'y2': 0
			},
			lastTime = performance.now(); //The time at which the last point was drawn

		function startLine(x, y, evt) {

			//Prevent the press from being interpreted by the browser
			evt.preventDefault();

			curLineId = Tools.generateUID("s"); //"s" for straight line

			Tools.drawAndSend({
				'type': 'straight',
				'id': curLineId,
				'color': Tools.getColor(),
				'size': Tools.getSize(),
				'x': x,
				'y': y
			});

			curUpdate.id = curLineId;
		}

		function continueLine(x, y, evt) {
			/*Wait 70ms before adding any point to the currently drawing line.
			This allows the animation to be smother*/
			if (curLineId !== "") {
				curUpdate['x2'] = x; curUpdate['y2'] = y;
				if (performance.now() - lastTime > 70) {
					Tools.drawAndSend(curUpdate);
					lastTime = performance.now();
				} else {
					draw(curUpdate);
				}
			}
			if (evt) evt.preventDefault();
		}

		function stopLine(x, y) {
			//Add a last point to the line
			continueLine(x, y);
			curLineId = "";
		}

		function draw(data) {
			switch (data.type) {
				case "straight":
					createLine(data);
					break;
				case "update":
					var line = svg.getElementById(data['id']);
					if (!line) {
						console.error("Straight line: Hmmm... I received a point of a line that has not been created (%s).", data['id']);
						createLine({ //create a new line in order not to loose the points
							"id": data['id'],
							"x": data['x2'],
							"y": data['y2']
						});
					}
					updateLine(line, data);
					break;
				default:
					console.error("Straight Line: Draw instruction with unknown type. ", data);
					break;
			}
		}

		var svg = Tools.svg;
		function createLine(lineData) {
			//Creates a new line on the canvas, or update a line that already exists with new information
			var line = svg.getElementById(lineData.id) || Tools.createSVGElement("line");
			line.id = lineData.id;
			line.x1.baseVal.value = lineData['x'];
			line.y1.baseVal.value = lineData['y'];
			line.x2.baseVal.value = lineData['x2'] || lineData['x'];
			line.y2.baseVal.value = lineData['y2'] || lineData['y'];
			//If some data is not provided, choose default value. The line may be updated later
			line.setAttribute("stroke", lineData.color || "black");
			line.setAttribute("stroke-width", lineData.size || 10);
			svg.appendChild(line);
			return line;
		}

		function updateLine(line, data) {
			line.x2.baseVal.value = data['x2'];
			line.y2.baseVal.value = data['y2'];
		}

		Tools.add({ //The new tool
			"name": "Straight line",
			"icon": "☇",
			"listeners": {
				"press": startLine,
				"move": continueLine,
				"release": stopLine,
			},
			"draw": draw,
			"mouseCursor": "crosshair",
			"stylesheet": "/js/tools/line/line.css"
		});

	})(); //End of code isolation
}
