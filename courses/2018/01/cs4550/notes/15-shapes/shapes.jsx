
import React from 'react';
import ReactDOM from 'react-dom';
import Toolbox from './components/toolbox';
import Picture from './components/picture';

export default function shapes_init() {
  let root = document.getElementById('root');
  ReactDOM.render(<Shapes />, root);
}

function send_post(path, data, success) {
  let xhr = new XMLHttpRequest();
  xhr.open("POST", path);
  xhr.setRequestHeader('Content-Type', 'application/json; encoding=UTF-8');
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.onload = (evt) => {
    if (xhr.status >= 200 && xhr.status < 300) {
      success(xhr.response, evt, xhr);
    }
  };
  xhr.send(JSON.stringify(data));
}

function send_get(path, success) {
  let xhr = new XMLHttpRequest();
  xhr.open("GET", path);
  xhr.setRequestHeader('Content-Type', 'application/json; encoding=UTF-8');
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.onload = (evt) => {
    if (xhr.status >= 200 && xhr.status < 300) {
      success(xhr.response, evt, xhr);
    }
  };
  xhr.send("");
}

class Shapes extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tools: { color: "blue", shape: "circ", rad: 10, x: 50, y: 50, w: 100, h: 100 },
      circs: [],
      rects: [],
    };

    this.reload();
  }

  reload() {
    send_get("/api/v1/circs", (resp) => {
      resp = JSON.parse(resp);
      console.log("circs", resp);
      this.setState(Object.assign({}, this.state, { circs: resp.data || [] }));
    });
    send_get("/api/v1/rects", (resp) => {
      resp = JSON.parse(resp);
      console.log("rects", resp);
      this.setState(Object.assign({}, this.state, { rects: resp.data || [] }));
    });
  }

  changeTools(params) {
    let tools = Object.assign({}, this.state.tools, params);
    this.setState(Object.assign({}, this.state, { tools: tools }));
  }

  addShape() {
    let tools = this.state.tools;
    console.log("add shape", tools);
    if (tools.shape == "circ") {
      this.addCirc(tools);
    }
    else {
      this.addRect(tools);
    }

    this.reload();
  }

  addCirc(tools) {
    let circ = tools;
    send_post("/api/v1/circs", {circ: circ}, (resp) => {
      console.log(resp);
    });
  }

  addRect(tools) {
    let rect = tools;
    send_post("/api/v1/rects", {rect: rect}, (resp) => {
      console.log(resp);
    });
  }

  render() {
    console.log(this.state);
    return (
      <div>
        <Toolbox root={this} tools={this.state.tools} />
        <Picture root={this} circs={this.state.circs} rects={this.state.rects} />
      </div>
    );
  }
}

