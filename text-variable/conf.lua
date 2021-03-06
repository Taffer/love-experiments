-- Default configuration for Love2D experiments.
--
-- By Chris Herborth (https://github.com/Taffer)
-- MIT license, see LICENSE.md for details.

function love.conf(t)
    -- "Native" window size matches the Switch. Some day, I'd like to port
    -- things there.
    t.window.title = 'Expriment 3 - Variable Width Text'
    t.window.width = 1280
    t.window.height = 720

    t.identity = 'ca.taffer.love-experiments-3'
    t.version = 11.3 -- Made with LOVE 11.3 (Mysterious Mysteries).
    t.console = true
end
