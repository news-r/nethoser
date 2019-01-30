#' Visualise
#'
#' Visualise nethoser network.
#'
#' @param graph A list as returned by \code{\link{net_con}}.
#'
#' @examples
#' data("webhoser")
#'
#' # make network
#' webhoser %>%
#'   net_con(thread.site, entities.persons) %>% 
#'   net_vis()
#' 
#' @rdname viz
#' @export
net_vis <- function(graph){
  nodes <- graph$nodes %>% 
    select(label = name, size = n) %>% 
    mutate(id = label) 
  
  edges <- graph$edges %>% 
    select(source, target, weight = n) %>% 
    mutate(id = 1:dplyr::n())

  sigmajs() %>%
    sg_nodes(nodes, id, label, size) %>%
    sg_edges(edges, id, source, target, weight) %>%
    sg_layout() %>%
    sg_cluster(
      colors = c(
        "#05143a", "#acadaf"
      )
    ) %>%
    sg_drag_nodes()  %>%
    sg_neighbours()
}

#' @export
#' @rdname viz
net_viz <- net_vis
