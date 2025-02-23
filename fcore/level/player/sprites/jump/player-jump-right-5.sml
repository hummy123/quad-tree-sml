structure PlayerJumpRight5 =
struct
  fun lerp (startX, startY, drawWidth, drawHeight, windowWidth, windowHeight, r, g, b) : Real32.real vector =
    let
       val endY = windowHeight - startY
       val startY = windowHeight - (startY + drawHeight)
       val endX = startX + drawWidth
       val windowHeight = windowHeight / 2.0
       val windowWidth = windowWidth / 2.0
    in
       #[      (((startX * (1.0 - 0.125)) + (endX * 0.125)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.150000035763)) + (endY * 0.150000035763)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.125)) + (endX * 0.125)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.1875)) + (endX * 0.1875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.1875)) + (endX * 0.1875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.1875)) + (endX * 0.1875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.150000035763)) + (endY * 0.150000035763)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.125)) + (endX * 0.125)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.150000035763)) + (endY * 0.150000035763)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.1875)) + (endX * 0.1875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.0499999821186)) + (endY * 0.0499999821186)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.1875)) + (endX * 0.1875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.25)) + (endX * 0.25)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.25)) + (endX * 0.25)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.25)) + (endX * 0.25)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.0499999821186)) + (endY * 0.0499999821186)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.1875)) + (endX * 0.1875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.0499999821186)) + (endY * 0.0499999821186)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.3125)) + (endX * 0.3125)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.25)) + (endX * 0.25)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.25)) + (endX * 0.25)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.25)) + (endX * 0.25)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.3125)) + (endX * 0.3125)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.3125)) + (endX * 0.3125)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.5625)) + (endX * 0.5625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.0499999821186)) + (endY * 0.0499999821186)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.6875)) + (endX * 0.6875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.0499999821186)) + (endY * 0.0499999821186)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.6875)) + (endX * 0.6875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.6875)) + (endX * 0.6875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.5625)) + (endX * 0.5625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.5625)) + (endX * 0.5625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.0499999821186)) + (endY * 0.0499999821186)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.6875)) + (endX * 0.6875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.6875)) + (endX * 0.6875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.6875)) + (endX * 0.6875)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.100000023842)) + (endY * 0.100000023842)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.625)) + (endX * 0.625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.625)) + (endX * 0.625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.5)) + (endX * 0.5)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.5)) + (endX * 0.5)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.5)) + (endX * 0.5)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.625)) + (endX * 0.625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.375)) + (endX * 0.375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.375)) + (endX * 0.375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.375)) + (endX * 0.375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.950000047684)) + (endY * 0.950000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.950000047684)) + (endY * 0.950000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.950000047684)) + (endY * 0.950000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0, r, g, b,
      (((startX * (1.0 - 0.375)) + (endX * 0.375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.5)) + (endX * 0.5)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.5)) + (endX * 0.5)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.5)) + (endX * 0.5)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.375)) + (endX * 0.375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.375)) + (endX * 0.375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.625)) + (endX * 0.625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.75)) + (endX * 0.75)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.625)) + (endX * 0.625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.700000047684)) + (endY * 0.700000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.625)) + (endX * 0.625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.799999952316)) + (endY * 0.799999952316)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.950000047684)) + (endY * 0.950000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.950000047684)) + (endY * 0.950000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.950000047684)) + (endY * 0.950000047684)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 1.0)) + (endX * 1.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 1.0)) + (endX * 1.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.9375)) + (endX * 0.9375)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 1.0)) + (endX * 1.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 1.0)) + (endX * 1.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 1.0)) + (endX * 1.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 1.0)) + (endX * 1.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.25)) + (endY * 0.25)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0)) + (endX * 0.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0)) + (endX * 0.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0625)) + (endX * 0.0625)) / windowWidth) - 1.0,
      (((startY * (1.0 - 0.200000017881)) + (endY * 0.200000017881)) / windowHeight) - 1.0,
0.0,
0.0,
0.0,
      (((startX * (1.0 - 0.0)) + (endX * 0.0)) / windowWidth) - 1.0,
      (((startY * (1.0 - 1.0)) + (endY * 1.0)) / windowHeight) - 1.0,
0.0,
0.0,
0.0
    ]
  end
end
