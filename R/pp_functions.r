#' @importFrom grImport2 pictureGrob readPicture
cc_file <- pictureGrob(readPicture(system.file("extdata/by-sa-svg.svg", package="piecepack")))

is_odd <- function(x) { as.logical(x %% 2) }

#' Inch utility function
#'
#' This utility function is equivalent to \code{grid::unit(x, "in")}.
#' 
#' @param x Number representing number of inches
#' @export
inch <- function(x) { unit(x, "in") }

make_deck_header <- function(cfg) {
    make_header_helper(cfg$deck_title, cfg)
}

make_die_viewports <- function(label, flip=FALSE) {
    if (flip) {
        addViewport(x=4/4-1/8, y=1/3-1/6, width=1/4, height=1/3, angle= 90, name=paste0(label, ".die.1"))
        addViewport(x=3/4-1/8, y=1/3-1/6, width=1/4, height=1/3, angle=  0, name=paste0(label, ".die.2"))
        addViewport(x=3/4-1/8, y=2/3-1/6, width=1/4, height=1/3, angle= 90, name=paste0(label, ".die.3"))
        addViewport(x=2/4-1/8, y=2/3-1/6, width=1/4, height=1/3, angle=  0, name=paste0(label, ".die.4"))
        addViewport(x=2/4-1/8, y=3/3-1/6, width=1/4, height=1/3, angle= 90, name=paste0(label, ".die.5"))
        addViewport(x=1/4-1/8, y=3/3-1/6, width=1/4, height=1/3, angle=  0, name=paste0(label, ".die.6"))
    } else {
        addViewport(x=1/4-1/8, y=1/3-1/6, width=1/4, height=1/3, angle=-90, name=paste0(label, ".die.1"))
        addViewport(x=2/4-1/8, y=1/3-1/6, width=1/4, height=1/3, angle=  0, name=paste0(label, ".die.2"))
        addViewport(x=2/4-1/8, y=2/3-1/6, width=1/4, height=1/3, angle=-90, name=paste0(label, ".die.3"))
        addViewport(x=3/4-1/8, y=2/3-1/6, width=1/4, height=1/3, angle=  0, name=paste0(label, ".die.4"))
        addViewport(x=3/4-1/8, y=3/3-1/6, width=1/4, height=1/3, angle=-90, name=paste0(label, ".die.5"))
        addViewport(x=4/4-1/8, y=3/3-1/6, width=1/4, height=1/3, angle=  0, name=paste0(label, ".die.6"))
    }
}

make_4by3_viewports <- function(label) {
    for (i_row in 1:3) {
        i_l_rank <- 2 * (i_row-1) + 1
        i_r_rank <- 2 * (i_row-1) + 2
        addViewport(y=(4-i_row)/3-1/6, height=1/3, name=paste0(label, ".row.", i_row))
        downViewport(paste0(label, ".row.", i_row))
        addViewport(x=0.125, width=0.25, name=paste0(label, ".face.", i_l_rank))
        addViewport(x=0.375, width=0.25, name=paste0(label, ".back.", i_l_rank))
        addViewport(x=0.625, width=0.25, name=paste0(label, ".face.", i_r_rank))
        addViewport(x=0.875, width=0.25, name=paste0(label, ".back.", i_r_rank))
        upViewport()
    }
}

make_coinrow_viewports <- function(label) {
    for (i_r in 1:6) {
        addViewport(x=(2*i_r-1)/12-1/24, width=1/12, name=paste0(label, ".back.", i_r))
        addViewport(x=(2*i_r)/12-1/24, width=1/12, name=paste0(label, ".face.", i_r))
    }
}

draw_coin_4by3 <- function(i_s, cfg) {
    label <- stringi::stri_rand_strings(n=1, length=4)
    make_4by3_viewports(label)
    for(i_r in 1:6) {
        seekViewport(paste0(label, ".back.", i_r))
        draw_component("coin_back", cfg, i_s)
        seekViewport(paste0(label, ".face.", i_r))
        draw_component("coin_face", cfg, i_r=i_r)
    }
}

draw_piecepack_die <- function(i_s, cfg, flip=FALSE) {
    suppressWarnings({
        # label <- stringi::stri_rand_strings(n=1, length=4)
        label <- "piecepack"
        make_die_viewports(label, flip=flip)
        if (cfg$pp_die_arrangement == "opposites_sum_to_5")
            arrangement <- c(1, 2, 3, 6, 5, 4)
        else
            arrangement <- 1:6
        for(i_face in 1:6) {
            i_r <- arrangement[i_face]
            downViewport(paste0(label, ".die.", i_face))
            draw_component("ppdie_face", cfg, i_s, i_r)
            upViewport()
        }
    })
}

draw_suit_die <- function(cfg, flip=FALSE) {
    suppressWarnings({
        # label <- stringi::stri_rand_strings(n=1, length=4)
        label <- "suit"
        make_die_viewports(label, flip=flip)
        if (cfg$n_suits == 4) {
            downViewport(paste0(label, ".die.1"))
            draw_component("suitdie_face", cfg, 6)
            upViewport()
            for (i_s in 1:4) {
                downViewport(paste0(label, ".die.", i_s+1))
                draw_component("suitdie_face", cfg, 5-i_s)
                upViewport()
            }
            downViewport(paste0(label, ".die.6"))
            draw_component("suitdie_face", cfg, 5)
            upViewport()
        } else if (cfg$n_suits == 5) {
            for (i_s in 1:5) {
                downViewport(paste0(label, ".die.", i_s))
                draw_component("suitdie_face", cfg, 6-i_s)
                upViewport()
            }
            downViewport(paste0(label, ".die.6"))
            draw_component("suitdie_face", cfg, 6)
            upViewport()
        } else if (cfg$n_suits == 6) {
            for (i_s in 1:6) {
                downViewport(paste0(label, ".die.", i_s))
                draw_component("suitdie_face", cfg, 7-i_s)
                upViewport()
            }
        } else {
            stop(paste("Don't know how to draw suit die for", cfg$n_suits, "suits"))
        }
    })
}

draw_rank_die <- function(cfg, flip=FALSE) {
    suppressWarnings({
        label <- stringi::stri_rand_strings(n=1, length=4)
        make_die_viewports(label, flip=flip)
        for (i_r in 1:6) {
            seekViewport(paste0(label, ".die.", i_r))
            draw_component("ppdie_face", cfg, cfg$i_unsuit + 1, i_r)
        }
    })
}

draw_suitrank_die <- function(cfg, flip=FALSE) {
    suppressWarnings({
        # label <- stringi::stri_rand_strings(n=1, length=8)
        label <- "suitrank"
        make_die_viewports(label, flip=flip)
        if (cfg$n_suits == 4) {
            downViewport(paste0(label, ".die.1"))
            draw_component("ppdie_face", cfg, 6, 1)
            upViewport()
            downViewport(paste0(label, ".die.2"))
            draw_component("ppdie_face", cfg, 5, 2)
            upViewport()
            for (i_r in 3:6) {
                downViewport(paste0(label, ".die.", i_r))
                draw_component("ppdie_face", cfg, 5-(i_r-2), i_r)
                upViewport()
            }
        } else if (cfg$n_suits == 5) {
            downViewport(paste0(label, ".die.6"))
            draw_component("ppdie_face", cfg, 6, 6)
            upViewport()
            for (i_r in 1:5) {
                downViewport(paste0(label, ".die.", i_r))
                draw_component("ppdie_face", cfg, 6-i_r, i_r)
                upViewport()
            }
        } else if (cfg$n_suits == 6) {
            for (i_r in 1:6) {
                downViewport(paste0(label, ".die.", i_r))
                draw_component("ppdie_face", cfg, 7-i_r, i_r)
                upViewport()
            }
        } else {
            stop(paste("Don't know how to draw suit/rank die for", cfg$n_suits, "suits"))
        }
    })
}

make_header_helper <- function(title, cfg) {
    header_height <- 0.8
    y_header <- WIN_HEIGHT - header_height/2
    addViewport(y=inch(y_header), width=inch(6.0), height=inch(header_height), name="header")
    seekViewport("header")
    width_image = 0.14
    addViewport(y=0.85, height=0.2, name="title")
    addViewport(x=width_image/2, y=0.4, width=width_image, height=0.5, name="l_cc_image")
    addViewport(x=1-width_image/2, y=0.4, width=width_image, height=0.5, name="r_cc_image")
    addViewport(x=0.5, y=0.4, width=1-2*width_image, height=0.8, name="text")
    seekViewport("text")
    gp <- gpar(fontsize=9, fontfamily=cfg$header_font)
    # grid.text(cfg$program, x=0.0, y=0.8, just="left", gp=gp)
    # grid.text(cfg$copyright, x=0.0, y=0.6, just="left", gp=gp)
    # grid.text(cfg$license1, x=0.0, y=0.4, just="left", gp=gp)
    # grid.text(cfg$license2, x=0.0, y=0.2, just="left", gp=gp)
    grid.text(cfg$program, x=0.5, y=0.8, just="center", gp=gp)
    grid.text(cfg$copyright, x=0.5, y=0.6, just="center", gp=gp)
    grid.text(cfg$license1, x=0.5, y=0.4, just="center", gp=gp)
    grid.text(cfg$license2, x=0.5, y=0.2, just="center", gp=gp)
    seekViewport("l_cc_image")
    grid.draw(cc_file)
    seekViewport("r_cc_image")
    grid.draw(cc_file)
    seekViewport("title")
    gp <- gpar(fontsize=15, fontfamily=cfg$header_font, fontface="bold")
    grid.text(title, just="center", gp=gp)
}

make_preview_header <- function(cfg) {
    make_header_helper(cfg$title, cfg)
}

seekViewport <- function(...) { suppressWarnings(grid::seekViewport(...)) }

pp_pdf <- function(filename, family, paper) {
    if (paper == "letter") {
        cairo_pdf(filename, onefile=TRUE, width=8.5, height=11, family=family)
    } else if (paper == "A4") {
        cairo_pdf(filename, onefile=TRUE, width=8.3, height=11.7, family=family)
    } else {
        stop(paste("Don't know how to handle paper", paper))
    }
}

#' Make collection preview
#' 
#' Makes a preview pdf of a collection of pnp decks.
#'
#' @param cfg Piecepack configuration list
#' @export
make_collection_preview <- function(cfg) {
    dir.create(cfg$pdf_preview_dir, recursive=TRUE, showWarnings=FALSE)

    decks <- cfg$decks
    fp <- file.path(cfg$pdf_preview_dir, paste0(cfg$filename, ".pdf"))
    pp_pdf(fp, cfg$font, cfg$paper)

    n_pages <- ceiling(length(decks) / 6)

    for (ii in 1:n_pages) {

        jj <- (ii - 1) * 6 + 1

        l_logos <- list()
        for(kk in 0:5) {
            deck <- decks[jj+kk]
            if(is.na(deck))
                l_logos[[kk+1]] <- nullGrob()
            else
                l_logos[[kk+1]] <- pictureGrob(readPicture(file.path(cfg$svg_preview_dir, paste0(deck, ".svg")), warn=FALSE))
        }
        l_squares <- lapply(seq(along=l_logos), function(x) { rectGrob(gp=gpar(lty="dashed", col="grey", fill=NA)) })
        grid.newpage()
        vp <- viewport(x=inch(4.25), y=inch(5.0), width=inch(8), height=inch(8)) 
        pushViewport(vp)
        gridExtra::grid.arrange(grobs=l_logos, ncol=2, newpage=FALSE, padding=0)
        gridExtra::grid.arrange(grobs=l_squares, ncol=2, newpage=FALSE, padding=0)
        upViewport()
        make_preview_header(cfg)
    }

    if (is_odd(n_pages)) {
        grid.newpage()
        grid.text("This page intentionally left blank")
    }
    invisible(dev.off())
}

WIN_WIDTH <- 8
WIN_HEIGHT <- 10.5

mainViewport <- function() {
    addViewport(width=inch(WIN_WIDTH), height=inch(WIN_HEIGHT), name="main")
    downViewport("main")
}

draw_suit_page <- function(i_s, cfg) {
    grid.newpage()

    # Build viewports
    mainViewport()
    addViewport(y=inch(1.5*TILE_WIDTH), width=inch(4*TILE_WIDTH), height=inch(3*TILE_WIDTH), name="tiles")
    downViewport("tiles")
    make_4by3_viewports("tile")
    seekViewport("main")
    xpawn <- PAWN_WIDTH/2
    # pheight <- 2.5 * PAWN_HEIGHT
    pheight <- 2 * PAWN_HEIGHT + 2 * PAWN_BASE
    ypawn <- 3*TILE_WIDTH + pheight/2 
    addViewport(x=inch(xpawn), y=inch(ypawn), width=inch(PAWN_WIDTH), height=inch(pheight), name="lpawn")
    addViewport(x=inch(WIN_WIDTH-xpawn), y=inch(ypawn), width=inch(PAWN_WIDTH), height=inch(pheight), name="rpawn")

    xdie <- PAWN_WIDTH + 3*DIE_WIDTH/2 
    # ydie <- WIN_WIDTH - 4*DIE_WIDTH/2 - 0.125
    ydie <- 3*TILE_WIDTH + 4*DIE_WIDTH/2
    addViewport(x=inch(xdie) , y=inch(ydie), width=inch(2), height=inch(1.5), angle=-90, name="ldie")
    addViewport(x=inch(WIN_WIDTH-xdie) , y=inch(ydie), width=inch(2), height=inch(1.5),  angle=90, name="rdie")

    ysaucer <- 3*TILE_WIDTH + SAUCER_WIDTH/2
    addViewport(y=inch(ysaucer), height=inch(SAUCER_WIDTH), width=inch(4*SAUCER_WIDTH), name="saucers")
    seekViewport("saucers")
    draw_component("saucer_face", cfg, i_s, x=1/4-1/8)
    draw_component("saucer_back", cfg, x=2/4-1/8)
    draw_component("saucer_face", cfg, i_s, x=3/4-1/8)
    draw_component("saucer_back", cfg, x=4/4-1/8)
    seekViewport("main")
    # addViewport(y=inch(ycoin), width=inch(7.5), height=inch(0.625), name="coinrow")
    # ycoin <- 6+ 3*COIN_WIDTH
    ycoin <- ysaucer + SAUCER_WIDTH/2 + 3*COIN_WIDTH/2
    addViewport(y=inch(ycoin), width=inch(4 * COIN_WIDTH), height=inch(3 * COIN_WIDTH), name="coins")
    seekViewport("main")


    # ydie2 <- ybelt - 1.5*DIE_WIDTH
    ydie2 <- ydie + 2*DIE_WIDTH 
    addViewport(x=inch(xdie) , y=inch(ydie2), width=inch(2), height=inch(1.5), angle=-90, name="ldie2")
    addViewport(x=inch(WIN_WIDTH-xdie) , y=inch(ydie2), width=inch(2), height=inch(1.5),  angle=90, name="rdie2")

    # ybelt <- ycoin + 3*COIN_WIDTH/2 + DIE_WIDTH/2
    # xbelt <- WIN_WIDTH/2 - BELT_WIDTH/2
    ybelt <- ydie2 + DIE_WIDTH + DIE_WIDTH/2
    xbelt <- BELT_WIDTH/2
    draw_component("belt_face", cfg, i_s, x=inch(xbelt), y=inch(ybelt))
    draw_component("belt_face", cfg, i_s, x=inch(WIN_WIDTH-xbelt), y=inch(ybelt))

    # Draw components
    for (i_r in 1:6) {
        seekViewport(paste0("tile.face.", i_r))
        draw_component("tile_face", cfg, i_s, i_r)
        seekViewport(paste0("tile.back.", i_r))
        draw_component("tile_back", cfg)
    }

    # coins
    seekViewport("coins")
    draw_coin_4by3(i_s, cfg)

    # pawn and belt
    seekViewport("lpawn")
    draw_pawn(i_s, cfg)
    seekViewport("rpawn")
    draw_pawn(i_s, cfg)

    # die
    seekViewport("rdie")
    draw_piecepack_die(i_s, cfg)
    seekViewport("ldie")
    draw_piecepack_die(i_s, cfg, flip=TRUE)
    seekViewport("rdie2")
    draw_piecepack_die(i_s, cfg)
    seekViewport("ldie2")
    draw_piecepack_die(i_s, cfg, flip=TRUE)

    # annotations
    seekViewport("main")
    # grid.text("die", x=inch(xdie+0.5), y=inch(ydie+0.9))
    # grid.text("coins", y=inch( ycoin + 0.4))
    # grid.text("pawn", x=inch(3.25), y=inch(ypawn+0.5))
    # grid.text("pawn belt", x=inch(3.25), y=inch(ybelt+0.4))
    # grid.text("tiles", y=inch( 6.4))
    make_deck_header(cfg)

}

draw_accessories_page <- function(cfg, odd=TRUE) {
    grid.newpage()

    # Build viewports
    mainViewport()
    y_joker <- 8.75
    addViewport(y=inch(y_joker), x=0.5, width=inch(2*TILE_WIDTH), height=inch(TILE_WIDTH), name="joker.tiles")
    downViewport("joker.tiles")
    draw_component("tile_face", cfg, cfg$i_unsuit, cfg$n_ranks + 1, x=0.25)
    draw_component("tile_back", cfg, x=0.75)
    seekViewport("main")
    # dice
    ydh <- y_joker - DIE_WIDTH/2 + DIE_WIDTH
    ydm <- ydh - 3 * DIE_WIDTH
    ydl <- ydm - 3 * DIE_WIDTH
    ydb <- ydl - 3 * DIE_WIDTH
    die_xl = 2*DIE_WIDTH
    die_xm = die_xl + 2*DIE_WIDTH
    die_xh = die_xm + 2*DIE_WIDTH
    die_right <- die_xl + 0.8
    addViewport(y=inch(ydh), x=inch(die_xl), width=inch(2), height=inch(1.5), name="lsuitdie")
    addViewport(y=inch(ydh), x=inch(WIN_WIDTH-die_xl), width=inch(2), height=inch(1.5), name="rsuitdie")
    addViewport(y=inch(ydm-DIE_WIDTH), width=inch(2), height=inch(1.5), name="suitdie3")
    addViewport(y=inch(ydm), x=inch(WIN_WIDTH-die_xl), width=inch(2), height=inch(1.5), name="suitrankdie1")
    addViewport(y=inch(ydm), x=inch(WIN_WIDTH-die_xm), width=inch(2), height=inch(1.5), name="suitrankdie2")
    addViewport(y=inch(ydm), x=inch(die_xl), width=inch(2), height=inch(1.5), name="suitrankdie3")
    addViewport(y=inch(ydm), x=inch(die_xm), width=inch(2), height=inch(1.5), name="suitrankdie4")
    addViewport(y=inch(ydl), x=inch(WIN_WIDTH-die_xl), width=inch(2), height=inch(1.5), name="rankdie1")
    addViewport(y=inch(ydl), x=inch(WIN_WIDTH-die_xm), width=inch(2), height=inch(1.5), name="rankdie2")
    addViewport(y=inch(ydl), x=inch(WIN_WIDTH-die_xh), width=inch(2), height=inch(1.5), name="rankdie3")
    addViewport(y=inch(ydl), x=inch(die_xh), width=inch(2), height=inch(1.5), name="rankdie4")
    addViewport(y=inch(ydb), x=inch(WIN_WIDTH-die_xl), width=inch(2), height=inch(1.5), name="rankdie1l")
    addViewport(y=inch(ydb), x=inch(WIN_WIDTH-die_xm), width=inch(2), height=inch(1.5), name="rankdie2l")
    addViewport(y=inch(ydb), x=inch(WIN_WIDTH-die_xh), width=inch(2), height=inch(1.5), name="rankdie3l")
    addViewport(y=inch(ydb), x=inch(die_xh), width=inch(2), height=inch(1.5), name="rankdie4l")

    die_x <- c(die_xl, die_xm, die_xm, die_xl, die_xh, die_xh)
    die_y <- c(ydl, ydl, ydb, ydb, ydl, ydb)
    for (i_s in 1:cfg$n_suits) {
        addViewport(y=inch(die_y[i_s]), x=inch(die_x[i_s]), width=inch(2), height=inch(1.5), name=paste0("ppdie.", i_s))
        addViewport(y=inch((cfg$n_suits + 1 - i_s)*CHIP_WIDTH - 0.5*CHIP_WIDTH), 
                    width=inch(12*CHIP_WIDTH), height=inch(CHIP_WIDTH), name=paste0("chips.", i_s))
        seekViewport(paste0("chips.", i_s))
        for (i_r in 1:6) {
            draw_component("chip_back", cfg, i_s,      x=(2*i_r-1)/12-1/24)
            draw_component("chip_face", cfg, i_s, i_r, x=(2*i_r  )/12-1/24)
        }
        seekViewport("main")
    }
    if (cfg$n_suits <= 4) {
        saucer_y <- 4*CHIP_WIDTH + 0.5*SAUCER_WIDTH + 0.125
        addViewport(y=inch(saucer_y),width=inch(8*SAUCER_WIDTH), height=inch(SAUCER_WIDTH), name="pawnsaucers")
        seekViewport("pawnsaucers")
        for (i_s in 1:cfg$n_suits) {
            draw_component("saucer_face", cfg, i_s, x=(2*i_s-1)/8-1/16)
            draw_component("saucer_back", cfg,      x=(2*i_s  )/8-1/16)
        }
        seekViewport("main")
    }

    # Draw components
    seekViewport("rsuitdie")
    draw_suit_die(cfg)
    seekViewport("lsuitdie")
    draw_suit_die(cfg, flip=TRUE)
    seekViewport("suitdie3")
    if (odd)
        draw_suit_die(cfg)
    else
        draw_suit_die(cfg, flip=TRUE)
    seekViewport("suitrankdie1")
     draw_suitrank_die(cfg)
    seekViewport("suitrankdie2")
     draw_suitrank_die(cfg)
    seekViewport("suitrankdie3")
     draw_suitrank_die(cfg, flip=TRUE)
    seekViewport("suitrankdie4")
     draw_suitrank_die(cfg, flip=TRUE)
    seekViewport("rankdie1")
    draw_rank_die(cfg)
    seekViewport("rankdie2")
    draw_rank_die(cfg)
    seekViewport("rankdie3")
    draw_rank_die(cfg)
    if (cfg$n_suits < 5) {
        seekViewport("rankdie4")
        draw_rank_die(cfg, flip=TRUE)
    }
    seekViewport("rankdie1l")
    draw_rank_die(cfg)
    seekViewport("rankdie2l")
    draw_rank_die(cfg)
    seekViewport("rankdie3l")
    draw_rank_die(cfg)
    if (cfg$n_suits < 6) {
        seekViewport("rankdie4l")
        draw_rank_die(cfg, flip=TRUE)
    }
    for (i_s in 1:cfg$n_suits) {
        seekViewport(paste0("ppdie.", i_s))
        draw_piecepack_die(i_s, cfg, flip=TRUE)
    }

    # Annotations
    seekViewport("main")
    # for (i_s in 1:4) {
    #     grid.text(paste0("ppdie", i_s))
    # }
    # grid.text("joker tile", x=inch(0.8), y=inch(8.5), rot=90)
    # grid.text("additional piecepack dice", x=inch(0.8), y=inch((ydm+ydl)/2), rot=90)
    # grid.text("pawn\nsaucers", x=inch(1), y=inch(3.8), rot=90)
    # grid.text('chips', x=inch(0.4), y=inch(2), rot=90)
    # grid.text("suit die", x=inch(die_right), y=inch(ydh-0.3), rot=90)
    # grid.text("suit/rank die", x=inch(die_right), y=inch(ydl-0.3), rot=90)
    # grid.text("rank die", x=inch(die_right), y=inch(ydm-0.3), rot=90)
    make_deck_header(cfg)
}

#' Make print-and-play piecepack pdf
#'
#' Makes a print-and-play piecepack pdf.
#'
#' @param cfg Piecepack configuration list
#' @export
make_pnp_piecepack <- function(cfg) {
    directory <- cfg$pdf_deck_dir
    dir.create(directory, recursive=TRUE, showWarnings=FALSE)

    pdf_file <- file.path(directory, paste0(cfg$deck_filename, ".pdf"))
    unlink(pdf_file)

    pp_pdf(pdf_file, cfg$font, cfg$paper)

    for (i_s in 1:cfg$n_suits) {
        draw_suit_page(i_s, cfg)
    }
    if (is_odd(cfg$n_suits)) {
        draw_suit_page(cfg$i_unsuit+1, cfg)
    }

    # Accessories
    if ((cfg$n_suits >= 4) && (cfg$n_suits <= 6)) {
        draw_accessories_page(cfg)
        draw_accessories_page(cfg, odd=FALSE)
    }
    invisible(dev.off())
}

make_pdfmark_txt <- function(pm_filename, cfg) {
    deck_filenames <- file.path(cfg$pdf_deck_dir, paste0(cfg$decks, ".pdf"))
    n_sets <- length(deck_filenames)
    txt <- paste0("[ /Title (", cfg$title, ")\n /Author (", cfg$author, ")\n /Subject (", 
                cfg$subject, ")\n /Keywords (", cfg$keywords, ")\n /DOCINFO pdfmark")

    n_preview <- ceiling(n_sets / 6)
    if (is_odd(n_preview))
        n_preview <- n_preview + 1
    new_txt <- "[/Page 1 /View [/XYZ null null null] /Title (Piecepack Sets Preview) /OUT pdfmark"
    txt <- append(txt, new_txt)
    next_page <- n_preview + 1
    for(ii in 1:n_sets) {
        new_txt <- sprintf("[/Page %s /View [/XYZ null null null] /Title (Piecepack Set #%s) /OUT pdfmark", next_page, ii)
        txt <- append(txt, new_txt)
        next_page <- next_page + n_pages(deck_filenames[ii])
    }
    writeLines(txt, pm_filename)
}

n_pages_pdfinfo <- function(pdf_filename) {
    pdfinfo <- system2("pdfinfo", pdf_filename, stdout=TRUE)
    pdfinfo <- grep("^Pages:", pdfinfo, value=TRUE)
    as.numeric(strsplit(pdfinfo, " +")[[1]][2])
}
n_pages_gs <- function(pdf_filename) {
    cmd <- tools::find_gs_cmd()
    args <- c("-q", "-dNODISPLAY", "-c", paste(paste0('"(', pdf_filename, ")"),
              "(r)", "file", "runpdfbegin", "pdfpagecount", "=", 'quit"'))
    as.numeric(system2(cmd, args, stdout=TRUE))
}
n_pages <- function(pdf_filename) {
    if (Sys.which("pdfinfo") != "") {
        np <- n_pages_pdfinfo(pdf_filename)
    } else {
        np <- n_pages_gs(pdf_filename)
    }
    np
}

#' Collects print-and-play piecepack pdfs into one pdf
#'
#' Collects print-and-play piecepack pdfs into one pdf
#' with a preview at the beginning.
#'
#' @param cfg Piecepack configuration list
#' @export
make_collection <- function(cfg) {
    dir.create(cfg$pdf_collection_dir, recursive=TRUE, showWarnings=FALSE)

    deck_filenames <- shQuote(file.path(cfg$pdf_deck_dir, paste0(cfg$decks, ".pdf")))
    fp <- shQuote(file.path(cfg$pdf_preview_dir, paste0(cfg$filename, ".pdf")))
    # files <- paste(fp, paste(shQuote(deck_filenames), collapse=" "))

    # add bookmarks
    pm_filename <- tempfile(fileext=".txt")
    make_pdfmark_txt(pm_filename, cfg)
    bf <- shQuote(file.path(cfg$pdf_collection_dir, paste0(cfg$filename, ".pdf")))
    cmd <- tools::find_gs_cmd()
    args <- c("-q", "-o", bf, "-sDEVICE=pdfwrite", pm_filename, fp, deck_filenames)
    # bcommand <- paste("gs -q -o", bf, "-sDEVICE=pdfwrite", pm_filename, files)
    cat(cmd, args, "\n")
    system2(cmd, args)
}

get_collections <- function() {
    sub(".json$", "", list.files("svg", pattern=".json$"))
}
