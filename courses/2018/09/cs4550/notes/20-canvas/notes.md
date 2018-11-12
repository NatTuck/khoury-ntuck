---
layout: default
---

 - Project Questions?

## Basic Canvas

 - Type 2d-canvas.html
 - This shows a way to use the canvas 2D API. There are other approaches.

## React Konva Example

https://github.com/NatTuck/shapes

First, make sure we have Phoenix 1.4

https://phoenixframework.org/blog/phoenix-1-4-0-released

```
$ git clone https://github.com/NatTuck/shapes
```

Minimal React-Konva example, in shapes.jsx:


```
...
import { Stage, Layer, Circle } from 'react-konva';

export default function start(node) {
  ReactDOM.render(<Shapes />, document.getElementById('root'));
}

class Shapes extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return <div>
      <Stage width={1024} height={768}>
        <Layer>
          <Circle radius={20} x={100} y={100} fill="red" />
        </Layer>
      </Stage>
    </div>;
  }
}
```

Extend it to bouncing balls:

```
import _ from 'lodash';

export default function start(node) {
  ReactDOM.render(<Shapes />, document.getElementById('root'));
}

let W = 1024;
let H = 768;
let R = 50;
let G = 2;

class Shapes extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      balls: [
        {x: 100, y: 700, dx: 0, dy: -1},
        {x: 200, y: 650, dx: 0, dy: -1},
        {x: 300, y: 750, dx: 0, dy: -1},
      ],
    };

    window.setInterval(this.tick.bind(this), 100);
  }

  tick() {
    let balls = _.map(this.state.balls, ({x, y, dx, dy}) => {
      if (y + dy < R/2) {
        dy = -dy;
      }
      else {
        dy -= G;
      }
      y += dy;
      return {x, y, dx, dy};
    });
    this.setState(_.assign({}, this.state, {balls}));
  }

  render() {
    let circles = _.map(this.state.balls, (bb, ii) =>
      <Circle key={ii} radius={R} x={bb.x} y={H - bb.y} fill="red" />);

    return <div>
      <Stage width={W} height={H}>
        <Layer>
          {circles}
        </Layer>
      </Stage>
    </div>;
  }
}
```

Now add an onClick event:

```
  // in the loop in tick
  if ((x + dx < R / 2) || (x + dx > W - (R/2))) {
    dx = -dx;
  }
  x += dx;
   
  // new method
  push(bb) {
    let balls = _.map(this.state.balls, (ball, ii) =>
      (ii == bb ? _.assign({}, ball, {dx: ball.dx + 10}) : ball));
    this.setState(_.assign({}, this.state, {balls}));
  }


  // in render
  <Circle key={ii} radius={R} x={bb.x} y={H - bb.y} fill="red"
          onClick={() => this.push(ii)} />);
```

## WebGL

 - https://playcanv.as/e/p/44MRmJRU/
 




## Selected References

 - https://webgl2fundamentals.org/webgl/lessons/webgl-fundamentals.html
 - https://webgl2fundamentals.org/webgl/lessons/webgl-drawing-multiple-things.html

