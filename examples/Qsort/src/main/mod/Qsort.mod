IMPLEMENTATION MODULE Qsort;

PROCEDURE qsort(first, last: INTEGER; comp: CompProc; swap: SwapProc);
VAR
    bot, top: INTEGER;
BEGIN
    bot := first;
    top := last;
    WHILE bot < top DO;
        WHILE comp(bot, top) AND (bot < top) DO
            DEC(top)
        END;
        swap(bot, top);
        WHILE comp(bot, top) AND (bot < top) DO
            INC(bot)
        END;
        swap( bot, top);
    END; (* outer WHILE *)
    IF first < (bot-1) THEN
        qsort(first, bot-1, comp, swap)
    END;
    IF (bot+1) < last THEN
        qsort(bot+1, last, comp, swap)
    END;
END qsort;

END Qsort.
