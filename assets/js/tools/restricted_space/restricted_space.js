/**
 *
 */

if (window.Tools.boardActivated) {
	(function () { //Code isolation
		//Indicates the id of the shape the user is currently drawing or an empty string while the user is not drawing
		var curId = "",
			curUpdate = { //The data of the message that will be sent for every new point
				'type': 'update',
				'id': "",
				'x': 0,
				'y': 0,
				'x2': 0,
				'y2': 0
			},
			lastTime = performance.now(); //The time at which the last point was drawn

		function start(x, y, evt) {

			//Prevent the press from being interpreted by the browser
			evt.preventDefault();

			curId = Tools.generateUID("s"); // s = restricted_space

			Tools.drawAndSend({
				'type': 'restricted_space',
				'id': curId,
				'color': Tools.getColor(),
				'size': Tools.getSize(),
				'x': x,
				'y': y,
				'x2': x,
				'y2': y
			});

			curUpdate.id = curId;
			curUpdate.x = x;
			curUpdate.y = y;
		}

		function move(x, y, evt) {
			/*Wait 70ms before adding any point to the currently drawing shape.
			This allows the animation to be smother*/
			if (curId !== "") {
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

		function stop(x, y) {
			//Add a last point to the shape
			move(x, y);
			curId = "";
		}

		function draw(data) {
			switch (data.type) {
				case "restricted_space":
					createShape(data);
					break;
				case "update":
					var shape = svg.getElementById(data['id']);
					if (!shape) {
						console.error("Straight shape: Hmmm... I received a point of a restricted_space that has not been created (%s).", data['id']);
						createShape({ //create a new shape in order not to loose the points
							"id": data['id'],
							"x": data['x2'],
							"y": data['y2']
						});
					}
					updateShape(shape, data);
					break;
				default:
					console.error("Straight shape: Draw instruction with unknown type. ", data);
					break;
			}
		}

		const svg = Tools.svg;

		function createShape(data) {
			// Creates a new shape on the canvas, or update a shape that already exists with new information
			var shape = svg.getElementById(data.id) || Tools.createSVGElement("rect");
			shape.id = data.id;
			updateShape(shape, data);
			//If some data is not provided, choose default value. The shape may be updated later
			shape.setAttribute("stroke", data.color || "black");
			shape.setAttribute("stroke-width", data.size || 10);
			svg.appendChild(shape);

			return shape;
		}

		function updateShape(shape, data) {
			shape.x.baseVal.value = Math.min(data['x2'], data['x']);
			shape.y.baseVal.value = Math.min(data['y2'], data['y']);
			shape.width.baseVal.value = Math.abs(data['x2'] - data['x']);
			shape.height.baseVal.value = Math.abs(data['y2'] - data['y']);
		}

		Tools.add({ //The new tool
			"name": "Restricted Space",
			"icon": "",
			"listeners": {
				"press": start,
				"move": move,
				"release": stop,
			},
			"draw": draw,
			"mouseCursor": "crosshair",
			"stylesheet": "/js/tools/restricted_space/restricted_space.css"
		});

	})(); //End of code isolation
}
