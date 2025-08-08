<!--
  @component
  Generates an SVG bar chart.
 -->
<script>
	import { getContext } from 'svelte';

	const { data, xGet, yGet, xScale, yScale, x } = getContext('LayerCake');

	/**
	 * @typedef {Object} Props
	 * @property {string} [fill='#0d565c'] - The shape's fill color.
	 * @property {boolean} [showLabels=true] - Show the numbers for each bar
	 */

	/** @type {Props} */
	let { fill = '#0d565c', showLabels = true } = $props();
</script>

<g class="bar-group">
	{#each $data as d, i}
		{@const xValue = $x(d)}
		<rect
			class="group-rect"
			data-id={i}
			x={$xScale.range()[0]}
			y={$yGet(d)}
			height={$yScale.bandwidth()}
			width={$xGet(d)}
			{fill}
		></rect>
		{#if showLabels && xValue}
			<text class="bar-label" data-id={i} x={6} y={$yGet(d) + $yScale.bandwidth() / 2 + 5}
				>{d.datasets}
			</text>
		{/if}
	{/each}
</g>

<style>
	.bar-label {
		fill: #ffffff;
		font-family: var(--font-mono);
		font-size: var(--text-xsmall);
	}
</style>
