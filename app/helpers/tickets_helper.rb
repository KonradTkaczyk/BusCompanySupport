module TicketsHelper
  class Graph
    Vertex = Struct.new(:name, :neighbours, :dist, :prev)
    Edge = Struct.new(:v1, :v2, :distance)
    class Edge
      def vertices; [v1, v2];
    end
  end

  def initialize(graph)
    @vertices = {}
    @edges = []
    graph.each do |(v1, v2, dist)|
      @vertices[v1] = Vertex.new(v1, []) unless @vertices.has_key?(v1)
      vert1 = @vertices[v1]
      @vertices[v2] = Vertex.new(v2, []) unless @vertices.has_key?(v2)
      vert2 = @vertices[v2]
      vert1.neighbours << vert2
      vert2.neighbours << vert1
      @edges << Edge.new(vert1, vert2, dist)
    end
    @dijkstra_source = nil
  end
  attr_reader :vertices, :edges

  def edge(u, v)
    @edges.find {|e| e.vertices == [u, v] or e.vertices == [v, u]}
  end

  def dijkstra(source)
    q = vertices.values
    q.each {|v| v.dist = Float::INFINITY}
    source.dist = 0
    until q.empty?
      u = q.min_by {|vertex| vertex.dist}
      break if u == Float::INFINITY
      q.delete(u)
      u.neighbours.each do |v|
        if q.include?(v)
          alt = u.dist + edge(u,v).distance
          if alt < v.dist
            v.dist = alt
            v.prev = u
          end
        end
      end
    end
    @dijkstra_source = source
  end

  def shortest_path(source, target)
    dijkstra(source) unless @dijkstra_source == source
    path = []
    u = target
    until u.nil?
      path.unshift(u)
      u = u.prev
    end
    path
  end

  def to_s
    "#<%s vertices=%s edges=%s>" % [self.class.name, vertices.values.inspect, edges.inspect]
  end
end
end

