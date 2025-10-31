PlayerOutfitPalettePointers:
        table_width 2
        dw PlayerOutfitPalette_Classic
        dw PlayerOutfitPalette_Blue
        dw PlayerOutfitPalette_Green
        dw PlayerOutfitPalette_Purple
        assert_table_length NUM_PLAYER_OUTFITS

PlayerOutfitPalette_Classic:
        INCBIN "gfx/trainers/cal.gbcpal", middle_colors

PlayerOutfitPalette_Blue:
        INCBIN "gfx/trainers/misty.gbcpal", middle_colors

PlayerOutfitPalette_Green:
        INCBIN "gfx/trainers/erika.gbcpal", middle_colors

PlayerOutfitPalette_Purple:
        INCBIN "gfx/trainers/executive_m.gbcpal", middle_colors