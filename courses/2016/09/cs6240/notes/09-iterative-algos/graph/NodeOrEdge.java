package path;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.hadoop.io.Writable;

class NodeOrEdge implements Writable {
	public boolean edge;
	
	// Either
	public String name;
	public double dist; 
	
	// Node Only
	public String prev;
	public ArrayList<String> links;
	
	public NodeOrEdge() {
		edge = true;
		name = "";
		dist = Double.POSITIVE_INFINITY;
		prev = "";
		links = new ArrayList<String>();
	}

	@Override
	public void write(DataOutput out) throws IOException {
		out.writeBoolean(edge);
		out.writeUTF(name);
		out.writeDouble(dist);
		out.writeUTF(prev);
		
		out.writeInt(links.size());
		
		for (String dst : links) {
			out.writeUTF(dst);
		}
	}

	@Override
	public void readFields(DataInput in) throws IOException {
		edge = in.readBoolean();
		name = in.readUTF();
		dist = in.readDouble();
		prev = in.readUTF();
	
		int nn = in.readInt();
		links = new ArrayList<String>(nn);
		for (int ii = 0; ii < nn; ++ii) {
			links.add(in.readUTF());
		}
	}
}
