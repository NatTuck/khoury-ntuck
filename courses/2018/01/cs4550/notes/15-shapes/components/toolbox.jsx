
import React from 'react';

export default function Toolbox(props) {
  let root = props.root;
  let tools = props.tools;

  function changeColor(ev) {
    root.changeTools({ color: ev.target.value });
  }

  function changeShape(ev) {
    root.changeTools({ shape: ev.target.value });
  }

  let colors = ["red", "green", "blue", "cyan", "magenta", "yellow", "black"].map( (color) => {
    return <option key={color}>{color}</option>;
  });

  let shapes = ["circ", "rect"].map( (shape) => {
    return <option key={shape}>{shape}</option>;
  });


  let shapeTool;

  if (props.tools.shape == "circ") {
    shapeTool = <CircTool root={props.root} tools={props.tools} />;
  }
  else {
    shapeTool = <RectTool root={props.root} tools={props.tools} />;
  }

  return (
    <div>
      <select onChange={changeColor} value={tools.color}>
        {colors}
      </select>

      <select onChange={changeShape} value={tools.shape}>
        {shapes}
      </select>

      <span style={{marginLeft: "2em"}}>
        { shapeTool }
      </span>

      <button onClick={() => root.addShape()}>
        Add
      </button>
    </div>
  );
}

function CircTool(props) {
  let root = props.root;
  let tools = props.tools;

  return <span>
    <NumInput name="x" tools={tools} root={root} />
    <NumInput name="y" tools={tools} root={root} />
    <NumInput name="rad" tools={tools} root={root} />
  </span>;
}

function RectTool(props) {
  let root = props.root;
  let tools = props.tools;

  return <span>
    <NumInput name="x" tools={tools} root={root} />
    <NumInput name="y" tools={tools} root={root} />
    <NumInput name="w" tools={tools} root={root} />
    <NumInput name="h" tools={tools} root={root} />
  </span>;
}

function NumInput(props) {
  let key = props.name;
  let val = props.tools[name];

  function onChange(ev) {
    let vv = parseInt(ev.target.value);
    let mm = {}; mm[key] = vv;
    props.root.changeTools(mm);
  }

  return <span>
    { key } = <input type="number" onChange={onChange} value={val} />;
  </span>;
}

