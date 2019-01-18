globalVariables(
    c(
        ".",
        "target",
        "uuid",
        "doc"
    )
)

#' Entities
#'
#' Create network from entities
#'
#' @param data The data, as returned by \link[webhoser]{wh_collect}.
#' @param entity Entity to build network.
#'
#' @examples
#' data("webhoser")
#'
#' graph <- webhoser %>%
#'   net_entities(entities.persons)
#'
#' c(nodes, edges) %<-% graph
#'
#' @return A \code{list} of length 2 containing \code{data.frame}s:
#' \itemize{
#'   \item{\code{nodes}: Name of \code{entity} and \code{n}umber of occurences.}
#'   \item{\code{edges}: The \code{source}, \code{target}, and \code{n}umber of edges.}
#' }
#'
#' @note The returned nodes and edges form an \emph{undirected} graph.
#'
#' @export
net_entities <- function(data, entity){

    if(missing(data) || missing(entity))
        stop("Missing data or entity", call. = FALSE)

    entity_enquo <- dplyr::enquo(entity)

    edges <- data %>%
        select(
            doc = uuid,
            entity = !!entity_enquo
        ) %>%
        filter(entity != "") %>%
        tidyr::separate_rows(entity, sep = ",") %>%
        filter(!is.na(entity)) %>%
        split(.$doc) %>%
        purrr::map_df(function(x){
            tidyr::crossing(
                source = x$entity,
                target = x$entity
            )
        }) %>%
        filter(target > source) %>%
        count(source, target, sort = TRUE)

    nodes <- bind_rows(
        edges %>% select(entity = source, n),
        edges %>% select(entity = target, n)
    ) %>%
        group_by(entity) %>%
        summarise(n = sum(n)) %>%
        ungroup()

    list(
        nodes = nodes,
        edges = edges
    )

}

