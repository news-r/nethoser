globalVariables(
    c(
        "entity",
        "target",
        "weight",
        "label",
        "size",
        "uuid",
        "doc",
        "."
    )
)

#' Connect
#'
#' Create network from webhoser data.
#'
#' @param data The data, as returned by \link[webhoser]{wh_collect}.
#' @param from,to Columns to build network.
#'
#' @examples
#' data("webhoser")
#' 
#' # co-mentions
#' graph <- webhoser %>%
#'   connect(entities.persons)
#'
#' # unpack
#' c(nodes, edges) %<-% graph
#' 
#' # visualise
#' webhoser %>%
#'   connect(entities.persons, entities.locations) %>% 
#'   visualise()
#'
#' @return A \code{list} of length 2 containing \code{data.frame}s:
#' \itemize{
#'   \item{\code{nodes}: Name of \code{entity} and \code{n}umber of occurences.}
#'   \item{\code{edges}: The \code{source}, \code{target}, and \code{n}umber of edges.}
#' }
#'
#' @details The returned nodes and edges form an \emph{undirected} graph.
#'
#' @export
connect <- function(data, from, to = NULL){

    if(missing(data) || missing(from))
        stop("Missing data or from", call. = FALSE)

    from_enquo <- rlang::enquo(from)
    to_enquo <- rlang::enquo(to)
    has_to <- rlang::quo_is_null(to_enquo)
    
    if(has_to) message("Building co-mention graph")

    edges <- data %>%
        {
            if(has_to)
                select(., doc = uuid, from = !!from_enquo) %>% mutate(to = from)
            else
                select(., doc = uuid, from = !!from_enquo, to = !!to_enquo) 
        } %>% 
        distinct() %>% 
        filter(from != "", to != "") %>%
        tidyr::separate_rows(from, sep = ",") %>%
        tidyr::separate_rows(to, sep = ",") %>%
        distinct() %>% 
        filter(!is.na(from), !is.na(to)) %>%
        split(.$doc) %>%
        purrr::map_df(function(x){
            tidyr::crossing(
                source = x$to,
                target = x$from
            )
        }) %>%
        filter(target > source) %>%
        mutate(
            source = trimws(source),
            target = trimws(target)
        ) %>% 
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
