require "org2mindmap/version"
require 'json'
require 'Nokogiri'
require 'utils/utils'
require 'utils/data_loader'
require 'mods/basic_constructor'

module Org2mindmap
  # Constructor Module
  class ConstMod
    include Constructor, Utils, DataLoader
    def initialize(raw_content)
      @content = Utils.remove_empty_line(raw_content)
      @metadata_array, @main_content = Utils.partition_mm @content
      @full_content = 'Root' + "\n" + @main_content
      @data = DataLoader.from(__FILE__).read
    end

    def construct_metadata
      super @metadata_array
    end

    def construct_hasharray
      super @full_content
    end

    def construct_html(html, tags)
      if html.nil? || tags.nil?
        'nothing'
      else
        html = Nokogiri::HTML(html) if html.class == String
        dict = [{ :name=> 'metadata', :value => construct_metadata.to_json }] +
            [{ :name => 'data', :value => construct_hasharray[0].to_json }]
        html.at_css(tags).content = Utils.to_script dict
        html
      end
    end

    def construct_mmhtml
      construct_html Nokogiri::HTML(@data), 'script#data-script'
    end
  end
end

__END__
<!DOCTYPE html>
<meta charset="utf-8">
<style>

    .node {
        cursor: pointer;
    }

    .node circle {
        fill: #fff;
        stroke: steelblue;
        stroke-width: 1.5px;
    }

    .node text {
        font: 15px sans-serif;
    }

    .link {
        fill: none;
        stroke-width: 2.5px;
    }

</style>
<body>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.2.min.js"></script>
<!-- Data Segmentation -->
<script id="data-script">
</script>
<script>
    var color_table = {"RED":{"VL":"#ff8a80","L":"#ff5252","D":"#ff1744","VD":"#d50000"},"PINK":{"VL":"#ff80ab","L":"#ff4081","D":"#f50057","VD":"#c51162"},"PURPLE":{"VL":"#b388ff","L":"#7c4dff","D":"#651fff","VD":"#6200ea"},"INDIGO":{"VL":"#8c9eff","L":"#536dfe","D":"#3d5afe","VD":"#304ffe"},"BLUE":{"VL":"#82b1ff","L":"#448aff","D":"#2979ff","VD":"#2962ff"},"TEAL":{"VL":"#a7ffeb","L":"#64ffda","D":"#1de9b6","VD":"#00bfa5"},"CYAN":{"VL":"#84ffff","L":"#18ffff","D":"#00e5ff","VD":"#00b8d4"},"GREEN":{"VL":"#b9f6ca","L":"#69f0ae","D":"#00e676","VD":"#00c853"},"LIME":{"VL":"#f4ff81","L":"#eeff41","D":"#c6ff00","VD":"#aeea00"},"YELLOW":{"VL":"#ffff8d","L":"#ff0","D":"#ffea00","VD":"#ffd600"},"AMBER":{"VL":"#ffe57f","L":"#ffd740","D":"#ffc400","VD":"#ffab00"},"ORANGE":{"VL":"#ffd180","L":"#ffab40","D":"#ff9100","VD":"#ff6d00"},"DEEP_ORANGE":{"VL":"#ff9e80","L":"#ff6e40","D":"#ff3d00","VD":"#dd2c00"},"BLACK":{"M":"#000"},"WHITE":{"M":"#fff"},"DEFAULT":{"M":"#000"}};
</script>
<!-- Code Segmentation -->
<script>

    var margin = {top: 20, right: 120, bottom: 20, left: 120},
            width = 1080 - margin.right - margin.left,
            height = 800 - margin.top - margin.bottom;

    var i = 0,
            duration = 750,
            root, root1, root2;

    var roots;
    var orientations = {left: -1, right: 1};
    var color_level = ["M", "VD", "D", "L", "VL"];

    var line_len = 9, valve_len = 8,
            level_width = 150, line_width = 2.5,
            TITLE_FONT_SIZE = 15, FACTOR = 0.5;

    var tree = d3.layout.tree()
            .size([height, width]);

    var diagonal = d3.svg.diagonal()
            .projection(function (d) {
                //var deltaX = d.hasOwnProperty('text') ? d.text.length*10 : 0;
                return [d.y, d.x];
            });

    var header = d3.select("body")
            .append("h1")
            .text("Metadata here");

    var svg = d3.select("body").append("svg")
            .attr("width", width + margin.right + margin.left)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    console.log(color_table);
    console.log(data);

    draw(data);
    d3.select(self.frameElement).style("height", "800px");

    function draw(data) {
        root = data;
        root.x0 = height / 2;
        root.y0 = 0;

        roots = {left: root, right: root};
        update('right', root)
    }

    function collapse(d) {
        if (d.children) {
            d._children = d.children;
            d._children.forEach(collapse);
            d.children = null;
        }
    }

    function updateY(orient, cur, tot) {
        cur.y = tot + orient * (cur.hasOwnProperty('parent') ? cur.parent.text.length * (TITLE_FONT_SIZE - cur.depth) * FACTOR + level_width : 0);
        console.log(cur.y);
        if (cur.hasOwnProperty('children'))
            cur.children.forEach(function (el) {
                updateY(orient, el, cur.y);
            })
    }

    function update(mask, source) {

        var the_root = roots[mask];
        var orient = orientations[mask];

        // Compute the new tree layout.
        var nodes = tree.nodes(the_root).reverse(),
                links = tree.links(nodes);

        updateY(orient, the_root, 0);

//  // Normalize for fixed-depth.
//  nodes.forEach(function(d) {
//      var el = d, tot = 0;
//      while (el.hasOwnProperty('parent')) {
//          tot += el.parent.text.length * (TITLE_FONT_SIZE - d.depth);
//          el = el.parent;
//      }
//      d.y =  d.depth * level_width + tot;
//  });

        // Update the nodes…
        var node = svg.selectAll("g.node")
                .data(nodes, function (d) {
                    return d.id || (d.id = ++i);
                });

        // Enter any new nodes at the parent's previous position.
        var nodeEnter = node.enter().append("g")
                .attr("class", "node")
                .attr("transform", function (d) {
                    return "translate(" + source.y0 + "," + source.x0 + ")";
                })
                .on("click", function (d) {
                    if (d.children) {
                        d._children = d.children;
                        d.children = null;
                    } else {
                        d.children = d._children;
                        d._children = null;
                    }
                    update(mask, d);
                });

        nodeEnter.append("line")
                .attr("id", "line1")
                .attr("x1", function (d) {
                    return 0;
                })
                .attr("y1", function (d) {
                    return 0;
                })
                .attr("x2", function (d) {
                    return orient * d.text.length * (TITLE_FONT_SIZE - d.depth) * FACTOR;
                })
                .attr("y2", function (d) {
                    return 0;
                })
                .style("stroke-width", line_width)
                .style("stroke", function (d) {
                    return color_table[d.color][color_level[d.depth]]
                });

        nodeEnter.append("text")
                .attr("x", -8)
                .attr("y", -10)
                .attr("dy", ".35em")
                .attr("text-anchor", "begin")
                .text(function (d) {
                    return d.text;
                })
                .style("font-size", function (d) {
                    return (TITLE_FONT_SIZE - d.depth) + "px";
                })
                .style("fill-opacity", 1e-6);

        nodeEnter.append("line")
                .attr("id", "line2")
                .attr("x1", function (d) {
                    return orient * d.text.length * (TITLE_FONT_SIZE - d.depth) * FACTOR / 2 - valve_len;
                })
                .attr("y1", 0)
                .attr("x2", function (d) {
                    return orient * d.text.length * (TITLE_FONT_SIZE - d.depth) * FACTOR / 2 + valve_len;
                })
                .attr("y2", 0)
                .attr("transform", function (d) {
                    var angle = d._children ? orient * 45 : 180, centerX = orient * d.text.length * (TITLE_FONT_SIZE - d.depth) * FACTOR / 2;
                    return "rotate(" + angle + "," + centerX + "," + 0 + ")";
                })
                .style("stroke-width", line_width)
                .style("stroke", function (d) {
                    return color_table[d.color][color_level[d.depth]]
                });

        //transform = "rotate(-45 100 100)"

        // Transition nodes to their new position.
        var nodeUpdate = node.transition()
                .duration(duration)
                .attr("transform", function (d) {
                    return "translate(" + d.y + "," + d.x + ")";
                });

        nodeUpdate.select("#line1")
                .style("fill-opacity", 1);

        nodeUpdate.select("text")
                .style("fill-opacity", 1);

        nodeUpdate.select("#line2")
                .attr("transform", function (d) {
                    var angle = d._children ? orient * 45 : 180, centerX = orient * d.text.length * (TITLE_FONT_SIZE - d.depth) * FACTOR / 2;
                    return "rotate(" + angle + "," + centerX + "," + 0 + ")";
                });

        // Transition exiting nodes to the parent's new position.
        var nodeExit = node.exit().transition()
                .duration(duration)
                .attr("transform", function (d) {
                    return "translate(" + source.y + "," + source.x + ")";
                })
                .style("opacity", 1e-6)
                .remove();

        nodeExit.select("#line2")
                .attr("transform", function (d) {
                    var angle = d._children ? orient * 45 : 180, centerX = orient * d.text.length * (TITLE_FONT_SIZE - d.depth) * FACTOR / 2;
                    return "rotate(" + angle + "," + centerX + "," + 0 + ")";
                });

        // Update the links…
        var link = svg.selectAll("path.link")
                .data(links, function (d) {
                    return d.target.id;
                });

        // Enter any new links at the parent's previous position.
        link.enter().insert("path", "g")
                .attr("class", "link")
                .attr("d", function (d) {
                    var o = {x: source.x0, y: source.y0};
                    return diagonal({source: o, target: o});
                })
                .style("stroke", function (d) {
                    return color_table[d.target.color][color_level[d.target.depth]]
                });

        // Transition links to their new position.
        link.transition()
                .duration(duration)
                .attr("d", function (d) {
                    var deltaY = d.source.hasOwnProperty('text') ? d.source.text.length * (TITLE_FONT_SIZE - d.source.depth) * FACTOR : 0;
                    var o = {x: d.source.x, y: d.source.y + orient * deltaY};
                    var p = {x: d.target.x, y: d.target.y};
                    return diagonal({source: o, target: p});
                });

        // Transition exiting nodes to the parent's new position.
        link.exit().transition()
                .duration(duration)
                .attr("d", function (d) {
                    var o = {x: source.x, y: source.y};
                    return diagonal({source: o, target: o});
                })
                .remove();

        // Stash the old positions for transition.
        nodes.forEach(function (d) {
            d.x0 = d.x;
            d.y0 = d.y;
        });
    }
</script>
