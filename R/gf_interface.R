#' Retrieve a GraphFrame
#'
#' @rdname spark_graphframe
#'
#' @param ... additional arguments, not used
#' @export
spark_graphframe <- function(x, ...) {
  UseMethod("spark_graphframe")
}

#' @rdname spark_graphframe
#' @template roxlate-gf-x
#' @export
spark_graphframe <- function(x, ...) {
  x$graphframe
}

#' Create a new GraphFrame
#' @param vertices a tbl_spark representing vertices
#' @param edges a tbl_psark representing edges
#' @export
gf_graphframe <- function(vertices = NULL, edges) {
  # vertices <- spark_dataframe(vertices)
  # edges <- spark_dataframe(edges)
  sc <- edges %>%
    spark_dataframe() %>%
    spark_connection()

  g <- if (is.null(vertices)) {
    invoke_static(sc,
                  "org.graphframes.GraphFrame",
                  "fromEdges",
                  spark_dataframe(edges))
  } else {
    invoke_new(sc,
               "org.graphframes.GraphFrame",
               spark_dataframe(vertices),
               spark_dataframe(edges))
  }

  object <- list(vertices = g %>%
                   invoke("vertices") %>%
                   sdf_register(),
                 edges = g %>%
                   invoke("edges") %>%
                   sdf_register(),
                 graphframe = g)

  class(object) <- "graphframe"

  object
}

#' @export
print.graphframe <- function(x, ...) {
  cat("Vertices", sep = "\n")
  print(x$vertices)
  print_newline()
  cat("Edges", sep = "\n")
  print(x$edges)
  invisible(x)
}

#' Extract vertices DataFrame
#' @template roxlate-gf-x
#' @export
gf_vertices <- function(x) {
  x$vertices
}

#' Extract edges DataFrame
#' @template roxlate-gf-x
#' @export
gf_edges <- function(x) {
  x$edges
}

#' Triplets of graph
#'
#' @template roxlate-gf-x
#' @export
gf_triplets <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("triplets") %>%
    sdf_register()
}

#' Register a GraphFrame object
#'
#' @template roxlate-gf-x
#' @export
gf_register <- function(x) {
  UseMethod("gf_register")
}

#' @export
gf_register.spark_jobj <- function(x) {
  object <- list(vertices = x %>%
                   invoke("vertices") %>%
                   sdf_register(),
                 edges = x %>%
                   invoke("edges") %>%
                   sdf_register(),
                 graphframe = x)
  class(object) <- "graphframe"
  object
}

#' @export
gf_register.graphframe <- function(x) {
  x
}

#' Vertices column names
#'
#' @template roxlate-gf-x
#' @export
gf_vertex_columns <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("vertexColumns") %>%
    unlist()
}

#' Edges column names
#'
#' @template roxlate-gf-x
#' @export
gf_edge_columns <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("edgeColumns") %>%
    unlist()
}

#' Out-degrees of vertices
#'
#' @template roxlate-gf-x
#' @export
gf_out_degrees <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("outDegrees") %>%
    sdf_register()
}

#' In-degrees of vertices
#'
#' @template roxlate-gf-x
#' @export
gf_in_degrees <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("inDegrees") %>%
    sdf_register()
}

#' Degrees of vertices
#'
#' @template roxlate-gf-x
#' @export
gf_degrees <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("degrees") %>%
    sdf_register()
}

#' Motif finding: Searching the graph for structural patterns
#' @template roxlate-gf-x
#'
#' @param pattern pattern specifying a motif to search for
#'
#' @export
gf_find <- function(x, pattern) {
  ensure_scalar_character(pattern)

  x %>%
    spark_graphframe() %>%
    invoke("find", pattern) %>%
    sdf_register()
}

#' Cache the GraphFrame
#'
#' @template roxlate-gf-x
#'
#' @export
gf_cache <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("cache")
}

#' Persist the GraphFrame
#'
#' @template roxlate-gf-x
#'
#' @param storage.level The storage level to be used. Please view the
#'   \href{http://spark.apache.org/docs/latest/programming-guide.html#rdd-persistence}{Spark Documentation}
#'   for information on what storage levels are accepted.
#'
#' @export
gf_persist <- function(x, storage.level = "MEMORY_AND_DISK") {
  ensure_scalar_character(storage.level)

  x %>%
    spark_graphframe() %>%
    invoke("persist", storage.level)
}

#' Unpersist the GraphFrame
#'
#' @template roxlate-gf-x
#'
#' @param blocking whether to block until all blocks are deleted
#'
#' @export
gf_unpersist <- function(x, blocking = FALSE) {
  ensure_scalar_boolean(blocking)

  x %>%
    spark_graphframe() %>%
    invoke("unpersist", blocking)
}

