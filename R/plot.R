#' Visualise
#' 
#' Visualise nethoser network.
#' 
#' @param graph A list as returned by \code{\link{connect}}.
#' 
#' @examples 
#' data("webhoser")
#' 
#' # make network
#' webhoser %>%
#'   connect(thread.site, entities.persons) %>% 
#'   visualize()
#' 
#' @rdname viz
#' @export
visualize <- function(graph){
  nodes <- graph$nodes %>% 
    select(label = entity, size = n) %>% 
    mutate(id = label) 
  
  edges <- graph$edges %>% 
    select(source, target, weight = n) %>% 
    mutate(id = 1:dplyr::n())
    
  sigmajs() %>% 
    sg_nodes(nodes, id, label, size) %>% 
    sg_edges(edges, id, source, target, weight) %>% 
    sg_layout() %>% 
    sg_cluster() %>% 
    sg_drag_nodes()  %>% 
    sg_neighbours()
}

#' @export
#' @rdname viz
visualise <- visualize