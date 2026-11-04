/* Shared helpers, measured data and the navigation, used by every page. */
"use strict";

var $ = function (s, r) { return (r || document).querySelector(s); };
var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };
function el(t, c, x) {
  var n = document.createElement(t);
  if (c) n.className = c;
  if (x !== undefined) n.textContent = x;
  return n;
}
function fmt(n) { return Math.round(n).toLocaleString("en-US"); }

/* ---- the site's pages, in order ---- */
var PAGES = [
  { href: "index.html",      label: "Overview" },
  { href: "run.html",        label: "Live run" },
  { href: "model.html",      label: "Build a model" },
  { href: "benchmarks.html", label: "Benchmarks" },
  { href: "api.html",        label: "API" },
  { href: "docs.html",       label: "Docs" }
];

function buildNav() {
  var host = $("#nav-links");
  if (!host) return;
  var here = (location.pathname.split("/").pop() || "index.html").toLowerCase();
  PAGES.forEach(function (p) {
    var li = el("li");
    var a = el("a", "nl", p.label);
    a.href = p.href;
    if (p.href.toLowerCase() === here) a.classList.add("on");
    li.appendChild(a);
    host.appendChild(li);
  });
}

/* ================= measured data =================
   Every figure below was produced by a harness committed under runs/headline/,
   run with nothing else on the machine and repeated. The one projected number
   is labelled wherever it appears. */

var RUN = {
  wall: 69.6,
  rtt: 0.301,
  rows: 100400,
  pgRows: 85400,
  connectPerTable: 3.42,
  preflight: 8.88,
  schema: 3.06,
  finalize: 11.75
};

var TABLES = [
  { n: "categories",  rows: 400,   gen: 0.05, load: 2.03, bytes: 200029 },
  { n: "users",       rows: 10000, gen: 2.52, load: 3.12, bytes: 1173648 },
  { n: "orders",      rows: 15000, gen: 2.03, load: 3.94, bytes: 3267675 },
  { n: "products",    rows: 20000, gen: 2.77, load: 5.16, bytes: 11015108 },
  { n: "order_items", rows: 40000, gen: 0.38, load: 3.14, bytes: 1603369 },
  { n: "reviews",     rows: 15000, gen: 1.78, load: 0,    bytes: 0 }
];
var LOAD_ORDER = ["categories", "users", "orders", "products", "order_items"];
var FILES = [
  { t: "users",    sink: "csv",  bytes: 1180773,  s: 0.08 },
  { t: "products", sink: "json", bytes: 15218899, s: 0.32 },
  { t: "reviews",  sink: "csv",  bytes: 7335580,  s: 0.12 }
];
var STRATS = {
  copy:           { trips: 5,     load: 17.39, projected: false },
  execute_values: { trips: 86,    load: 40.67, projected: false },
  rowwise:        { trips: 85400, load: 25961, projected: true }
};

var GEN_BENCH = [
  { t: "order_items", rows: 40000, before: 62.93, after: 0.41 },
  { t: "reviews",     rows: 15000, before: 24.24, after: 1.74 },
  { t: "orders",      rows: 15000, before:  8.30, after: 2.09 },
  { t: "products",    rows: 20000, before:  3.08, after: 2.65 },
  { t: "users",       rows: 10000, before:  2.62, after: 2.60 },
  { t: "categories",  rows:   400, before:  0.07, after: 0.05 }
];
var GEN_TOTAL = { rows: 100400, before: 101.24, after: 10.06 };

var REALISM = [
  ["users.birth_date implied age", "0.0 - 2.0 yrs", "18.0 - 79.99 yrs"],
  ["users under 18", "10,000 / 10,000", "0 / 10,000"],
  ["orders before the user registered", "49.8%  (7,467)", "0%"],
  ["reviews before the product existed", "49.9%  (7,479)", "0%"],
  ["line totals wrong", "100%  (40,000)", "0%"],
  ["order totals wrong", "100%  (13,969)", "0%"],
  ["users.total_spent wrong", "100%  (10,000)", "0%"],
  ["unit_price unrelated to product", "58.4%  (23,368)", "0%"],
  ["products priced at or below cost", "50.0%  (9,992)", "0%"],
  ["category names using _N fallback", "~370 / 400", "0 / 400"],
  ["distinct product names", "30 / 20,000", "20,000 / 20,000"]
];

var REGIMES = [
  { n: "rowwise · 85,400 trips", tot: "25,961 s  projected", wait: 94 },
  { n: "execute_values · 86 trips", tot: "40.67 s  measured", wait: 61 },
  { n: "copy · 5 trips", tot: "18.61 s  measured", wait: 8 }
];
var FORMATS = [
  { n: "JSON", mb: 14.51, rel: "1.38x CSV", win: false },
  { n: "CSV", mb: 10.55, rel: "baseline", win: false },
  { n: "Parquet", mb: 6.32, rel: "0.60x CSV", win: true }
];

/* The shipped model with its real field definitions, so the builder shows and
   exports exactly what the Python pipeline reads. */
var SHIPPED = [
{"name":"categories","rows":400,"fmt":"postgres","fields":[{"n":"id","t":"integer","pk":1,"ai":1},{"n":"name","t":"string","uq":1,"len":100},{"n":"description","t":"text","null":1},{"n":"parent_id","t":"integer","fk":"categories.id","null":1},{"n":"is_active","t":"boolean"},{"n":"created_at","t":"timestamp"}]},
{"name":"users","rows":10000,"fmt":"csv","fields":[{"n":"id","t":"integer","pk":1,"ai":1},{"n":"username","t":"string","uq":1,"len":50},{"n":"email","t":"string","uq":1,"len":255},{"n":"full_name","t":"string","len":200},{"n":"phone","t":"string","null":1,"len":20},{"n":"birth_date","t":"date","null":1},{"n":"registration_date","t":"timestamp"},{"n":"status","t":"enum","v":["active","inactive","suspended"]},{"n":"total_spent","t":"decimal","p":12,"s":2}]},
{"name":"products","rows":20000,"fmt":"json","fields":[{"n":"id","t":"integer","pk":1,"ai":1},{"n":"sku","t":"string","uq":1,"len":50},{"n":"name","t":"string","len":255},{"n":"description","t":"text","null":1},{"n":"category_id","t":"integer","fk":"categories.id"},{"n":"price","t":"decimal","p":10,"s":2},{"n":"cost","t":"decimal","p":10,"s":2},{"n":"stock_quantity","t":"integer"},{"n":"weight","t":"decimal","null":1,"p":8,"s":3},{"n":"is_active","t":"boolean"},{"n":"created_at","t":"timestamp"}]},
{"name":"orders","rows":15000,"fmt":"api","fields":[{"n":"id","t":"integer","pk":1,"ai":1},{"n":"order_number","t":"string","uq":1,"len":20},{"n":"user_id","t":"integer","fk":"users.id"},{"n":"order_date","t":"timestamp"},{"n":"total_amount","t":"decimal","p":12,"s":2},{"n":"tax_amount","t":"decimal","p":10,"s":2},{"n":"shipping_cost","t":"decimal","p":8,"s":2},{"n":"status","t":"enum","v":["pending","processing","shipped","delivered","cancelled"]},{"n":"shipping_address","t":"json"},{"n":"payment_method","t":"string","len":50}]},
{"name":"order_items","rows":40000,"fmt":"postgres","fields":[{"n":"id","t":"integer","pk":1,"ai":1},{"n":"order_id","t":"integer","fk":"orders.id"},{"n":"product_id","t":"integer","fk":"products.id"},{"n":"quantity","t":"integer"},{"n":"unit_price","t":"decimal","p":10,"s":2},{"n":"total_price","t":"decimal","p":12,"s":2},{"n":"discount_amount","t":"decimal","p":8,"s":2}]},
{"name":"reviews","rows":15000,"fmt":"csv","fields":[{"n":"id","t":"integer","pk":1,"ai":1},{"n":"product_id","t":"integer","fk":"products.id"},{"n":"user_id","t":"integer","fk":"users.id"},{"n":"rating","t":"integer"},{"n":"review_text","t":"text","null":1},{"n":"created_at","t":"timestamp"}]}
];

var PG_BACKED = ["postgres", "postgresql", "api"];

/* ---- model graph: the pipeline's own algorithms ---- */
function fksOf(t) {
  return (t.fields || []).filter(function (f) { return !!f.fk; }).map(function (f) {
    var parts = String(f.fk).split(".");
    return { field: f.n, ref: parts[0], refField: parts[1] || "id", nullable: !!f["null"] };
  });
}
function deps(t, model) {
  var names = {}, out = {};
  model.forEach(function (x) { names[x.name] = 1; });
  fksOf(t).forEach(function (fk) {
    if (fk.ref !== t.name && names[fk.ref]) out[fk.ref] = 1;
  });
  return Object.keys(out).sort();
}
/* Kahn's algorithm, ties broken by name, so the order never depends on
   iteration order. Mirrors ModelGraph.topological_order. */
function topoOrder(model) {
  var remaining = {}, byName = {}, order = [];
  model.forEach(function (t) { remaining[t.name] = 1; byName[t.name] = t; });
  function left() { return Object.keys(remaining); }
  while (left().length) {
    var ready = left().filter(function (n) {
      return deps(byName[n], model).every(function (d) { return !remaining[d]; });
    }).sort();
    if (!ready.length) ready = [left().sort()[0]];
    ready.forEach(function (n) { order.push(n); delete remaining[n]; });
  }
  return order;
}
function waves(model, scope) {
  var inScope = {}, remaining = {}, byName = {}, levels = [];
  scope.forEach(function (n) { inScope[n] = 1; remaining[n] = 1; });
  model.forEach(function (t) { byName[t.name] = t; });
  function left() { return Object.keys(remaining); }
  while (left().length) {
    var ready = left().filter(function (n) {
      return deps(byName[n], model)
        .filter(function (d) { return inScope[d]; })
        .every(function (d) { return !remaining[d]; });
    }).sort();
    if (!ready.length) ready = [left().sort()[0]];
    levels.push(ready);
    ready.forEach(function (n) { delete remaining[n]; });
  }
  return levels;
}
/* Transitive closure to a fixpoint. The original expanded only one level, which
   silently dropped a dependency of a dependency. */
function pgClosure(model) {
  var byName = {}, result = {}, pending = [];
  model.forEach(function (t) {
    byName[t.name] = t;
    if (PG_BACKED.indexOf(t.fmt) >= 0) pending.push(t.name);
  });
  while (pending.length) {
    var n = pending.pop();
    if (result[n]) continue;
    result[n] = 1;
    deps(byName[n], model).forEach(function (d) { if (!result[d]) pending.push(d); });
  }
  return result;
}
function cycles(model) {
  var byName = {}, found = [];
  model.forEach(function (t) { byName[t.name] = t; });
  model.map(function (t) { return t.name; }).sort().forEach(function (start) {
    var seen = {}, stack = [[start, [start]]];
    while (stack.length) {
      var it = stack.pop(), node = it[0], path = it[1];
      deps(byName[node], model).forEach(function (d) {
        if (d === start && path.length > 1) {
          var key = path.slice().sort().join(",");
          if (!found.some(function (f) { return f.join(",") === key; })) {
            found.push(path.slice().sort());
          }
        } else if (!seen[d]) { seen[d] = 1; stack.push([d, path.concat([d])]); }
      });
    }
  });
  return found;
}

/* ================= pipeline board =================
   Renders a run the way a CI board does: one card per stage, each moving from
   pending to running to succeeded, with the steps inside it ticking off and a
   final panel reporting what the database actually holds afterwards.

   It is driven entirely by the event stream serve_demo.py publishes, so what
   you watch is the real pipeline, not a re-enactment. */

var BOARD_STAGES = [
  { id: "preflight", nm: "preflight", note: "connect, probe latency" },
  { id: "schema",    nm: "schema",    note: "drop, create, defer keys" },
  { id: "generate",  nm: "generate",  note: "rows, then semantic repair" },
  { id: "output",    nm: "write",     note: "database, then file sinks" },
  { id: "finalize",  nm: "finalize",  note: "keys, sequences, verify" },
  { id: "published", nm: "published",  note: "read back from the database" }
];

function PipelineBoard(opts) {
  var boardHost = opts.board;
  var logHost = opts.log;
  var pubHost = opts.published;
  var statusHost = opts.status;

  var cards = {};
  var steps = {};          /* stage id -> { key -> {node, valueNode} } */
  var t0 = 0, ticker = null, finished = false;

  function mkIcon(state) {
    if (state === "ok") return "✓";
    if (state === "bad") return "✗";
    if (state === "running") return "●";
    return "";
  }

  function render() {
    boardHost.innerHTML = "";
    cards = {}; steps = {};
    BOARD_STAGES.forEach(function (sd) {
      var card = el("div", "bstage pending");
      var head = el("div", "bhead");
      var icon = el("span", "bicon", "");
      var name = el("span", "bname", sd.nm);
      var dur = el("span", "bdur", "—");
      head.appendChild(icon); head.appendChild(name); head.appendChild(dur);
      card.appendChild(head);
      card.appendChild(el("div", "bnote", sd.note));
      var sl = el("div", "bsteps");
      card.appendChild(sl);
      boardHost.appendChild(card);
      cards[sd.id] = { card: card, icon: icon, dur: dur, note: $(".bnote", card), steps: sl };
      steps[sd.id] = {};
    });
  }

  function setStage(id, state, duration, note) {
    var c = cards[id];
    if (!c) return;
    c.card.className = "bstage " + state;
    c.icon.textContent = mkIcon(state);
    if (duration !== undefined && duration !== null) {
      c.dur.textContent = Number(duration).toFixed(2) + " s";
    } else if (state === "running") {
      c.dur.textContent = "running";
    }
    if (note) c.note.textContent = note;
  }

  function step(stageId, key, label, state, value) {
    var c = cards[stageId];
    if (!c) return;
    var entry = steps[stageId][key];
    if (!entry) {
      var node = el("div", "bstep");
      var m = el("span", "m", "○");
      var t = el("span", null, label);
      var v = el("span", "v", "");
      node.appendChild(m); node.appendChild(t); node.appendChild(v);
      c.steps.appendChild(node);
      entry = steps[stageId][key] = { node: node, mark: m, value: v };
    }
    entry.node.className = "bstep" + (state ? " " + state : "");
    entry.mark.textContent = state === "ok" ? "✓" : (state === "run" ? "●" : "○");
    if (value !== undefined) entry.value.textContent = value;
  }

  function log(level, msg) {
    if (!logHost) return;
    var cls = "l";
    if (level === "ERROR" || level === "CRITICAL" || level === "WARNING") cls += " warn";
    else if (/verified|validated|passed|added and|SUCCESS/i.test(msg)) cls += " ok";
    var line = el("div", cls);
    var secs = t0 ? (performance.now() - t0) / 1000 : 0;
    var pad = secs.toFixed(2);
    while (pad.length < 6) pad = " " + pad;
    line.appendChild(el("span", "ts", pad + "  "));
    line.appendChild(document.createTextNode(msg));
    logHost.appendChild(line);
    while (logHost.childNodes.length > 700) logHost.removeChild(logHost.firstChild);
    logHost.scrollTop = logHost.scrollHeight;
  }

  function setStatus(text, bold) {
    if (!statusHost) return;
    statusHost.innerHTML = "";
    if (bold) {
      statusHost.appendChild(el("b", null, bold));
      statusHost.appendChild(document.createTextNode(" " + text));
    } else {
      statusHost.appendChild(document.createTextNode(text));
    }
  }

  function tick() {
    if (ticker) clearInterval(ticker);
    t0 = performance.now();
    ticker = setInterval(function () {
      if (finished) return;
      setStatus("elapsed", ((performance.now() - t0) / 1000).toFixed(1) + " s");
    }, 200);
  }

  function publish(ev) {
    if (!pubHost) return;
    pubHost.innerHTML = "";
    var head = el("div", "pub-h");
    head.appendChild(document.createTextNode("in the database now"));
    var badge = el("span", "badge", ev.host_kind || "database");
    head.appendChild(badge);
    pubHost.appendChild(head);

    var table = el("table"), body = el("tbody");
    var empty = 0;
    ev.tables.forEach(function (t) {
      var tr = el("tr");
      tr.appendChild(el("td", null, t.table));
      var v = el("td", t.rows ? "some" : "zero",
                 t.rows === null ? "missing" : fmt(t.rows) + " rows");
      if (!t.rows) empty++;
      tr.appendChild(v);
      body.appendChild(tr);
    });
    var tr = el("tr", "tot");
    tr.appendChild(el("td", null, "total · " + ev.foreign_keys + " foreign keys"));
    tr.appendChild(el("td", null, fmt(ev.total_rows) + " rows"));
    body.appendChild(tr);
    table.appendChild(body);
    pubHost.appendChild(table);

    setStage("published", empty ? "bad" : "ok", undefined,
      empty ? empty + " table(s) empty" : "all tables hold rows");
    step("published", "readback", "read back from database", "ok",
         fmt(ev.total_rows) + " rows");
  }

  return {
    reset: function () {
      finished = false;
      render();
      if (logHost) logHost.innerHTML = "";
      if (pubHost) pubHost.innerHTML = "";
      setStatus("idle");
      if (ticker) { clearInterval(ticker); ticker = null; }
    },
    handle: function (ev) {
      if (ev.type === "run" && ev.state === "start") {
        this.reset();
        tick();
        setStage("preflight", "running");
        step("preflight", "connect", "connect and probe latency", "run");
        log("INFO", "Run started · scale " + ev.options.scale
          + " · " + ev.options.strategy
          + (ev.options.offline ? " · offline" : ""));
      } else if (ev.type === "plan") {
        setStage("preflight", "ok", undefined, ev.tables.length + " tables planned");
        step("preflight", "connect", "connect and probe latency", "ok");
        step("preflight", "model", "validate the model", "ok",
             ev.tables.length + " tables");
        ev.tables.forEach(function (t) {
          step("generate", "g_" + t.table, t.table, null, fmt(t.rows));
          if (ev.postgres_closure.indexOf(t.table) >= 0) {
            step("output", "l_" + t.table, t.table, null, "queued");
          }
        });
        log("INFO", "Plan: " + ev.order.join(" → "));
      } else if (ev.type === "stage") {
        if (ev.state === "start") {
          setStage(ev.stage, "running");
          if (ev.stage === "schema") step("schema", "ddl", "apply DDL", "run");
          if (ev.stage === "finalize") {
            step("finalize", "fk", "add foreign keys", "run");
            step("finalize", "seq", "advance sequences", null);
            step("finalize", "ver", "verify row counts", null);
          }
        } else {
          setStage(ev.stage, ev.state === "failed" ? "bad" : "ok", ev.duration_s);
          if (ev.stage === "schema") step("schema", "ddl", "apply DDL", "ok", "1 round trip");
          if (ev.stage === "finalize") {
            step("finalize", "fk", "add foreign keys", "ok");
            step("finalize", "seq", "advance sequences", "ok");
            step("finalize", "ver", "verify row counts", "ok");
          }
        }
      } else if (ev.type === "table") {
        if (ev.phase === "generate") {
          step("generate", "g_" + ev.table, ev.table, "ok",
               fmt(ev.rows) + " · " + ev.duration_s.toFixed(2) + "s");
        } else if (ev.phase === "load") {
          step("output", "l_" + ev.table, ev.table, "ok",
               fmt(ev.rows) + " · " + ev.duration_s.toFixed(2) + "s");
        }
      } else if (ev.type === "file") {
        step("output", "f_" + ev.table + ev.sink, ev.table + " → " + ev.sink,
             "ok", fmt(ev.bytes / 1024) + " KB");
      } else if (ev.type === "published") {
        publish(ev);
      } else if (ev.type === "log") {
        log(ev.level, ev.msg);
      } else if (ev.type === "run") {
        finished = true;
        if (ticker) { clearInterval(ticker); ticker = null; }
        var good = ev.state === "done";
        setStatus(good ? "complete" : "failed",
                  ev.duration_s !== undefined ? ev.duration_s.toFixed(2) + " s" : "");
        if (!good) {
          BOARD_STAGES.forEach(function (sd) {
            if (cards[sd.id] && cards[sd.id].card.classList.contains("running")) {
              setStage(sd.id, "bad");
            }
          });
          if (ev.error) log("ERROR", ev.error);
        }
        if (ev.report && ev.report.verification) {
          var v = ev.report.verification;
          if (v.fk_constraints_added !== undefined) {
            step("finalize", "fk", "add foreign keys", "ok",
                 v.fk_constraints_added + " added, " + v.fk_violations + " violations");
          }
          if (v.sequences_advanced !== undefined) {
            step("finalize", "seq", "advance sequences", "ok", v.sequences_advanced);
          }
          if (v.row_counts_match !== undefined) {
            step("finalize", "ver", "verify row counts", v.row_counts_match ? "ok" : "run",
                 v.row_counts_match ? "matched" : "MISMATCH");
          }
          if (v.write_probe) {
            step("finalize", "probe", "application write probe", "ok", v.write_probe);
          }
        }
        if (!cards.published.card.classList.contains("ok")
            && !cards.published.card.classList.contains("bad")) {
          setStage("published", good ? "ok" : "bad", undefined,
                   good ? "offline run, nothing written to a database" : "not reached");
        }
      }
    },
    log: log,
    setStatus: setStatus
  };
}

document.addEventListener("DOMContentLoaded", buildNav);
