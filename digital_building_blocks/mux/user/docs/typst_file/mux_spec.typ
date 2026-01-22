#import "@preview/arkheion:0.1.1": arkheion, arkheion-appendices
#import "@preview/mitex:0.2.6": *
#import "@preview/cetz:0.4.2"
#import "@preview/circuiteria:0.2.0"
#show: arkheion.with(
  title: "2:1 多路复用器（mux2to1）Specification",
  authors: (
    (name: "geoffrey xu", email: "13149131068@163.com", affiliation: "xidian university", orcid: "0009-0006-1640-1812"),
  ),
  // insert your abstract after the colon, wrapped in brackets.
  // example: `abstract: [this is my abstract...]`
  //abstract: lorem(55),
  //keywords: ("first keyword", "second keyword", "etc."),
  date: "2026-01-22",
)

#set par(spacing: 1.5em)

#set text(
  font: ("Nimbus Roman", "AR PL UMing", "Droid Sans Fallback"),
  size: 12pt,
  lang: "zh",
) //设置正文字体, times new roman 是英文使用的字体, noto serif sc 是中文使用的字体.

#show heading: set text(font: "New Computer Modern") //设置标题字体

#set heading(numbering: "1.") //设置标题编号格式

#outline(depth: 4) //设置目录深度

// 注释掉 arkheion 模版中的这部分代码
#show heading: it => {
  // h1 and h2
  if it.level == 1 {
    pad(
      bottom: 10pt,
      it,
    )
  } else if it.level == 2 {
    pad(
      bottom: 8pt,
      it,
    )
  } else if it.level >= 3 {
    pad(
      bottom: 6pt,
      it,
    )
  } else {
    it
  }
}

#let titled-block(title: [], body, ..kwargs) = {
  stack(
    dir: ttb,
    spacing: 5pt,
    text(
      size: .9em,
      fill: rgb("#3140e4"),
      sym.triangle.small.stroked.r + sym.space + title,
    ),
    block(
      inset: 10pt,
      width: 100%,
      stroke: 2pt + rgb("#3140e4").lighten(50%),
      ..kwargs.named(),
      body,
    ),
  )
}

#let th(body) = align(horizon + center)[#body]
#let td(body) = {
  let s = repr(body)
  if s.contains(" ") or s.contains(":") or s.contains("：") or s.contains(",") or s.contains("，") {
    align(horizon + left)[#body]
  } else {
    align(horizon + center)[#body]
  }
}

#show raw.where(block: true): it => block(
  fill: luma(245),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  stroke: (left: 3pt + rgb("#3498db")),
  it,
)

#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

= Overview

== Functional Summary
- `mux2to1` 是一个纯组合逻辑的 2:1 多路复用器（Multiplexer）。
- `sel` 用于在 `in1` 与 `in2` 之间选择一路输出到 `out`。

== Performance Metrics
- Latency: 0 cycles（组合逻辑，仅存在门级传播延迟）。
- Throughput: 1 组输入/时钟（若在同步系统中每拍输入稳定一次，则每拍可产出一次有效输出）。
- Resource Estimation (PPA): 与 `INPUT_WIDTH` 线性相关（综合后一般为若干 LUT/门级 MUX；无寄存器、无存储资源）。

== Dependencies
- 无（不依赖厂商原语/第三方 IP；仅使用基础 Verilog 语法）。

= Configuration Parameters

#table(
  columns: (1.2fr, 1fr, 1fr, 2.2fr),
  align: (left, left, left, left),
  inset: 6pt,
  stroke: (x: 0.6pt, y: 0.6pt),
  th([Parameter Name]), th([Default Value]), th([Valid Range]), th([Description]),
  td([`INPUT_WIDTH`]), td([`8`]), td([`>= 1`]), td([输入/输出数据总线宽度（bit）]),
)

= Interface

== Signal List
#table(
  columns: (1.2fr, 1.2fr, .9fr, 1.2fr, 2fr),
  align: (left, left, left, left, left),
  inset: 6pt,
  stroke: (x: 0.6pt, y: 0.6pt),
  th([Name]), th([Width]), th([Direction]), th([Clock Domain]), th([Description]),
  td([`in1`]), td([`INPUT_WIDTH`]), td([Input]), td([N/A]), td([数据输入 1]),
  td([`in2`]), td([`INPUT_WIDTH`]), td([Input]), td([N/A]), td([数据输入 2]),
  td([`sel`]), td([`1`]), td([Input]), td([N/A]), td([选择信号：决定 `out` 连接到哪一路输入]),
  td([`out`]), td([`INPUT_WIDTH`]), td([Output]), td([N/A]), td([复用输出]),
)

== Timing Diagrams
- 该模块为组合逻辑，不涉及握手/时序协议。
- 对于任意输入变化，`out` 在综合后的传播延迟之后稳定；在同步系统中建议在同一时钟域内满足组合路径时序约束（setup/hold）。

== Protocol Definitions
- 无标准总线协议/握手协议。
- 选择关系（Truth Table）：
  #table(
    columns: (.8fr, 2fr),
    align: (left, left),
    inset: 6pt,
    stroke: (x: 0.6pt, y: 0.6pt),
    th([sel]), th([out]),
    td([`0`]), td([`out = in1`]),
    td([`1`]), td([`out = in2`]),
  )

= Register Map
- 无寄存器/CSR（Not Applicable）。

= Micro-Architecture

== Module Decomposition Tree (Functional Hierarchy)
#figure(
  caption: [模块分解图（Functional Hierarchy）],
  cetz.canvas(length: 1.0cm, padding: 14pt, {
    import cetz.draw: *
    import circuiteria.util: colors
    let border = black
    let card = colors.blue.lighten(70%)
    let shadow = rgb("#000000").transparentize(90%)

    rect(
      (0.12, -0.12),
      (8.42, 3.32),
      fill: shadow,
      stroke: none,
      radius: 8pt,
    )

    rect(
      (0, 0),
      (8.3, 3.2),
      fill: card,
      stroke: border + 1pt,
      radius: 8pt,
    )

    content((4.15, 2.75), anchor: "center", text(fill: gray.darken(10%), size: 1.5em)[mux top])
    content((4.15, 1.70), anchor: "center", text(size: 1.15em)[mux2to1])
  }),
)

== Block Diagrams & Sub-module Partitioning
#figure(
  caption: [微架构图（Micro-Architecture Block Diagram）],
  circuiteria.circuit({
    import "@preview/cetz:0.3.2": draw
    import circuiteria.element: multiplexer
    import circuiteria.wire: wire
    import circuiteria.util: colors
    multiplexer(
      x: 0,
      y: 0,
      w: 2.2,
      h: 3.8,
      entries: ("in1", "in2"),
      id: "mux",
      fill: colors.blue.lighten(70%),
    )
    draw.content((1.1, 1.9), anchor: "center", [mux2to1])

    wire(
      "w_in1",
      ((rel: (-1.4, 0), to: "mux-port-in0"), "mux-port-in0"),
      bus: true,
      directed: true,
    )
    wire(
      "w_in2",
      ((rel: (-1.4, 0), to: "mux-port-in1"), "mux-port-in1"),
      bus: true,
      directed: true,
    )
    wire(
      "w_out",
      ("mux-port-out", (rel: (1.3, 0), to: "mux-port-out")),
      bus: true,
      directed: true,
      name: "out",
    )
    wire(
      "w_sel",
      ((rel: (0, -1.4), to: "mux.south"), "mux.south"),
      directed: true,
      rotate-name: false,
    )
    draw.content(
      (rel: (0.18, 0), to: ("w_sel.start", 70%, "w_sel.end")),
      anchor: "west",
      [sel],
    )
  }),
)

== Key FSM Descriptions
- 无（组合逻辑，无状态机）。

== Data Flow Paths
- 单级选择路径：`out` 由 `sel` 决定连接 `in1` 或 `in2`。

== Error Handling
- 无（该模块不定义错误检测/报告机制）。

= Clock & Reset
- 无时钟/复位端口；不涉及 CDC 与复位策略。

= Integration & Usage

== Instantiation Template
```verilog
mux2to1 #(
  .INPUT_WIDTH (8)
) u_mux2to1 (
  .in1 (in1),
  .in2 (in2),
  .sel (sel),
  .out (out)
);
```

== Simulation Guide
- Testbench: `user/sim/mux2to1_tb.v`（对 `in1/in2/sel` 做全范围遍历）。
- Icarus Verilog（示例）：
```bash
mkdir -p prj/icarus
iverilog -g2012 -o prj/icarus/mux2to1_tb.vvp user/sim/mux2to1_tb.v user/src/mux2to1.v
vvp prj/icarus/mux2to1_tb.vvp
```
- 波形输出：默认写入 `prj/icarus/mux2to1.vcd`，可用 GTKWave 打开。
