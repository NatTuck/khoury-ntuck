---
layout: default
---

# First: project stuff

 - Project Questions?

## Shapes

Let's finish up the basics of the shapes app:

 - Support rectangles
   - Add a circ / rect drop down.
   - Tools change depending on which you pick.
 - Add a delete tool to the toolbox:
   - Clicking a shape fills in the delete ID / kind.
   - Clicking delete removes the selected shape.

## Access Your API With Scripts

### Elixir Client

```
$ mix new script_demo
```

Add some dependencies to mix.exs:

```
  {:httpoison, "~> 1.0"},
  {:poison, "~> 3.1"},
```

Download them:

```
$ mix deps.get
```

lib/script_demo.ex:

```
defmodule ScriptDemo do
  def circs_path do
    "http://localhost:4000/api/v1/circs"
  end

  def circs_path(id) do
    "#{circs_path()}/#{id}"
  end

  def list_circs do
    {:ok, resp} = HTTPoison.get(circs_path())
    Poison.decode(resp.body)
  end

  def update_circ(id, circ) do
    {:ok, text} = Poison.encode(%{ "circ" => circ })
    headers = [
      {"Content-Type", "application/json; charset=utf-8"},
      {"Accept", "application/json; charset=utf-8"},
    ]
    {:ok, _} = HTTPoison.put(circs_path(id), text, headers)
    :ok
  end
end
```

```
$ iex -S mix
iex> ScriptDemo.list_circs()
...
iex>ScriptDemo.update_circ(1, %{"color" => "red"})
```

paint_all.exs:

```
{:ok, %{ "data" => circs }} = ScriptDemo.list_circs()

Enum.each circs, fn cc ->
  IO.puts("Updating circ #{cc["id"]}")
  :ok = ScriptDemo.update_circ(cc["id"], %{ "color" => "red" })
end
```

```
$ mix run paint_all.exs
```

### Perl Client

```
$ sudo apt install perldoc libwww-perl libjson-perl
```

make_rects.pl:

```
#!/usr/bin/perl
use 5.20.0;
use warnings FATAL => 'all';

use HTTP::Request;
use LWP::UserAgent;
use JSON;


my $rect_url = "http://localhost:4000/api/v1/rects";

sub get_rects {
    my $ua = LWP::UserAgent->new();
    my $req = HTTP::Request->new(GET => $rect_url);
    $req->content_type("application/json; charset=UTF-8");
    $req->header("Accept", "application/json; charset=UTF-8");
    my $rsp = $ua->request($req);
    if ($rsp->is_success()) {
        my $body = decode_json($rsp->content());
        return $body->{data};
    }
    else {
        return undef;
    }
}

sub make_rect {
    my ($rect) = @_;
    my $ua = LWP::UserAgent->new();
    my $req = HTTP::Request->new(POST => $rect_url);
    $req->content_type("application/json; charset=UTF-8");
    $req->header("Accept", "application/json; charset=UTF-8");
    $req->content(encode_json({"rect" => $rect}));
    my $rsp = $ua->request($req);
    if ($rsp->is_success()) {
        my $body = decode_json($rsp->content());
        return $body->{data};
    }
    else {
        say $rsp->content();
        return undef;
    }
}

use Data::Dumper;

my $rects = get_rects();
#say Dumper($rects);

for (my $ii = 0; $ii < 4; ++$ii) {
    my $rr = {
        x => 300,
        y => 100 * $ii + 50,
        w => 60,
        h => 60,
        color => "green",
    };
    my $rr1 = make_rect($rr);
    my $id = $rr1->{id};
    say "Created: $id";
}
```

