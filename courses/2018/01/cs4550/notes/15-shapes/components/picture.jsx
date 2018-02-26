
import React from 'react';
import { Stage, Layer, Rect, Circle } from 'react-konva';

export default function Picture(props) {
  function clickShape(ev) {
    console.log("click", ev, ev.target);
  }

  let rects = props.rects.map((rr) => {
    return <Rect key={"r"+rr.id} x={rr.x} y={rr.y} width={rr.w} height={rr.h} fill={rr.color} />
  });

  let circs = props.circs.map((cc) => {
    return <Circle key={"c"+cc.id} x={cc.x} y={cc.y} radius={cc.rad}
                   fill={cc.color} data-id={cc.id} onClick={clickShape} />
  });

  return (
    <Stage width={800} height={600}>
      <Layer>
        { circs }
        { rects }
      </Layer>
    </Stage>
  );
}

