% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/game_systems.R
\name{game_systems}
\alias{game_systems}
\alias{to_hexpack}
\alias{to_subpack}
\title{Standard game systems}
\usage{
game_systems(style = NULL, round = FALSE, pawn = "token")

to_hexpack(cfg = getOption("piecepackr.cfg", pp_cfg()))

to_subpack(cfg = getOption("piecepackr.cfg", pp_cfg()))
}
\arguments{
\item{style}{If \code{NULL} (the default) uses suit glyphs from the default \dQuote{sans} font.
If \code{"dejavu"} it will use suit glyphs from the "DejaVu Sans" font
(must be installed on the system).}

\item{round}{If \code{TRUE} the \dQuote{shape} of \dQuote{tiles} and \dQuote{cards}
will be \dQuote{roundrect} instead of \dQuote{rect} (the default).}

\item{pawn}{If \code{"token"} (default) the piecepack pawn will be a two-sided token in a \dQuote{halma} outline,
if \code{"peg-doll"} the piecepack pawn will be a \dQuote{peg doll} style pawn, and
if \code{"joystick"} the piecepack pawn will be a \dQuote{joystick} style pawn.
Note for the latter two pawn styles only \code{pawn_top} will work with \code{grid.piece}.}

\item{cfg}{List of configuration options}
}
\description{
\code{game_systems} returns a list of \code{pp_cfg} objects
representing several game systems and pieces.
\code{to_subpack} and \code{to_hexpack} will attempt to generate matching (piecepack stackpack)
subpack and (piecepack) hexpack \code{pp_cfg} R6 objects respectively given a piecepack configuration.
}
\details{
Contains the following game systems:\describe{
\item{checkers1, checkers2}{Checkers and checkered boards in six color schemes.
Checkers are represented by a piecepackr \dQuote{bit}.  The \dQuote{board} \dQuote{face} is a checkered board
and the \dQuote{back} is a lined board.
Color is controlled by suit and number of rows/columns by rank.
\code{checkers1} has one inch squares and \code{checkers2} has two inch squares.}
\item{chess1, chess2}{Chess pieces and checkered boards in six color schemes.
Chess pieces are represented by a \dQuote{bit} (face).   The \dQuote{board} \dQuote{face} is a checkered board
and the \dQuote{back} is a lined board.
Color is controlled by suit and number of rows/columns by rank.
\code{chess1} has one inch squares and \code{chess2} has two inch squares.}
\item{dice}{Traditional six-sided pipped dice in six color schemes (color controlled by their suit).}
\item{dominoes, dominoes_black, dominoes_blue, dominoes_green, dominoes_red, dominoes_white, dominoes_yellow}{
Traditional pipped dominoes in six color schemes (\code{dominoes} and \code{dominoes_white} are the same).
In each color scheme the number of pips on the \dQuote{top} of the domino is
controlled by their \dQuote{rank} and on the \dQuote{bottom} by their \dQuote{suit}.}
\item{dual_piecepacks_expansion}{A companion piecepack with a special suit scheme.
See \url{https://trevorldavis.com/piecepackr/dual-piecepacks-pnp.html}.}
\item{go}{Go stones and lined boards in six color schemes.
Go stones are represented by a \dQuote{bit} and the board is a \dQuote{board}.
Color is controlled by suit and number of rows/columns by rank
Currently the "stones" look like "checkers" which is okay for 2D diagrams
but perhaps unsatisfactory for 3D diagrams.}
\item{hexpack}{A hexagonal extrapolation of the piecepack designed by Nathan Morse and Daniel Wilcox.
See \url{https://boardgamegeek.com/boardgameexpansion/35424/hexpack}.}
\item{meeples}{Standard 16mm x 16mm x 10mm \dQuote{meeples} in six colors represented by a \dQuote{bit}.}
\item{piecepack}{A public domain game system invented by James "Kyle" Droscha.
See \url{https://www.ludism.org/ppwiki}.
Configuration also contains the following piecepack accessories:\describe{
\item{piecepack dice cards}{An accessory proposed by John Braley.
See \url{https://www.ludism.org/ppwiki/PiecepackDiceCards}.}
\item{piecepack matchsticks}{A public domain accessory developed by Dan Burkey.
See \url{https://www.ludism.org/ppwiki/PiecepackMatchsticks}.}
\item{piecepack pyramids}{A public domain accessory developed by Tim Schutz.
See \url{https://www.ludism.org/ppwiki/PiecepackPyramids}.}
\item{piecepack saucers}{A public domain accessory developed by Karol M. Boyle at Mesomorph Games.
See \url{https://web.archive.org/web/20190719155827/http://www.piecepack.org/Accessories.html}.}
}}
\item{playing_cards, playing_cards_colored, playing_cards_tarot}{
Poker-sized \code{card} components for various playing card decks:\describe{
\item{playing_cards}{A traditional deck of playing cards with 4 suits
and 13 ranks (A, 2-10, J, Q, K) plus a 14th "Joker" rank.}
\item{playing_cards_colored}{Like \code{playing_cards} but with five colored suits:
red hearts, black spades, green clubs, blue diamonds, and yellow stars.}
\item{playing_cards_tarot}{A (French Bourgeois) deck of tarot playing cards:
first four suits are hearts, spades, clubs, and diamonds with
14 ranks (ace through jack, knight, queen, king) plus a 15th "Joker" rank
and a fifth "suit" of 22 trump cards (1-21 plus an "excuse").}}}
\item{playing_cards_expansion}{A piecepack with the standard \verb{French'' playing card suits. See \url{https://www.ludism.org/ppwiki/PlayingCardsExpansion}.\} \\item\{subpack\}\{A mini piecepack.  Designed to be used with the \code{piecepack} to make piecepack }stackpack'' diagrams.  See \url{https://www.ludism.org/ppwiki/StackPack}.}
}
}
\examples{
       cfgs <- game_systems()
       names(cfgs)

    if (require("grid")) {
       # standard dice
       grid.newpage()
       grid.piece("die_face", x=1:6, default.units="in", rank=1:6, suit=1:6,
                  op_scale=0.5, cfg=cfgs$dice)

       # dominoes
       grid.newpage()
       colors <- c("black", "red", "green", "blue", "yellow", "white")
       cfg <- paste0("dominoes_", rep(colors, 2))
       grid.piece("tile_face", x=rep(4:1, 3), y=rep(2*3:1, each=4), suit=1:12, rank=1:12+1,
                  cfg=cfg, default.units="in", envir=cfgs, op_scale=0.5)

       # various piecepack expansions
       grid.newpage()
       df_tiles <- data.frame(piece_side="tile_back", x=0.5+c(3,1,3,1), y=0.5+c(3,3,1,1),
                              suit=NA, angle=NA, z=NA, stringsAsFactors=FALSE)
       df_coins <- data.frame(piece_side="coin_back", x=rep(4:1, 4), y=rep(4:1, each=4),
                              suit=c(1,4,1,4,4,1,4,1,2,3,2,3,3,2,3,2),
                              angle=rep(c(180,0), each=8), z=1/4+1/16, stringsAsFactors=FALSE)
       df <- rbind(df_tiles, df_coins)
       pmap_piece(df, cfg = cfgs$playing_cards_expansion, op_scale=0.5, default.units="in")

       grid.newpage()
       pmap_piece(df, cfg = cfgs$dual_piecepacks_expansion, op_scale=0.5, default.units="in")
    }
}
\seealso{
\code{\link{pp_cfg}} for information about the \code{pp_cfg} objects returned by \code{game_systems}.
}
