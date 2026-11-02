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

document.addEventListener("DOMContentLoaded", buildNav);
