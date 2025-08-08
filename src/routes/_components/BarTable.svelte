<!--
	@component
	Makes an HTML table that is styled to look like a simple bar chart.
   -->
<script>
	import { max } from 'd3';

	let {
		data,
		count_var = 'count',
		group_var = 'group',
		count_label = 'Count',
		group_label = 'Group'
	} = $props();

	//calculate the max value for the dataset for bar length calculation
	const count_max = max(data, (d) => {
		return d[count_var];
	});

	data.sort((b, a) => a[count_var] - b[count_var]);

	/**
	 * @typedef {Object} Props
	 * @property {string} [count_var='count'] - Key name for counts attribute in data.
	 * @property {string} [group_var='group'] - Key name for groups attribute in data.
	 * @property {string} [count_label='Count'] - Text to use for count column for a screen reader.
	 * @property {string} [group_label] - Text to use for group column for a screen.
	 */
</script>

<table>
	<thead>
		<!-- Make a header visible only to screen readers -->
		<tr class="sr-only">
			<th class="name" scope="col">{group_label}</th>
			<th scope="col">{count_label}</th>
		</tr>
	</thead>
	<tbody>
		{#each data as d, i}
			<tr>
				<td class="name">{d[group_var]}</td>
				<td class="count">
					<!-- List the count in plain text for screen readers, draw a bar and label for visual viewers but hide from sr -->
					<span class="sr-only">{d[count_var]}</span>
					<div class="bar-container" aria-hidden="true">
						<div class="bar-max">
							<div
								class={'bar ' + d[group_var]}
								style="width: {100 * (d[count_var] / count_max)}%;"
							>
								&nbsp;
							</div>
						</div>
						<div class="text-holder">
							<div class="text-count" style="left: {100 * (d[count_var] / count_max)}%;">
								{d[count_var].toLocaleString('en-US')}
							</div>
						</div>
					</div>
				</td>
			</tr>
		{/each}
	</tbody>
</table>

<style>
	table {
		width: 100%;
		table-layout: auto;
		margin-bottom: 1em;
		font-family: var(--font-mono);
	}

	td {
		padding-top: 2px;
		padding-bottom: 2px;
	}

	th {
		font-weight: 400;
		text-align: left;
	}

	td.name,
	th.name {
		text-align: right;
		padding-right: 14px;
		width: 50px;
		font-size: var(--text-small);
	}

	.bar-container {
		position: relative;
		padding-bottom: 16px;
	}

	.bar-max {
		position: absolute;
		width: calc(100% - 45px);
		display: inline-block;
	}

	.bar {
		background: var(--color-darkgrey); /*if not overwritten by a specific class*/
		display: inline-block;
	}

	.Aggregate {
		background: var(--color-highlight);
	}

	.Microdata {
		background: var(--color-light);
	}

	.text-holder {
		display: inline-block;
		position: absolute;
		width: calc(100% - 45px);
	}

	.text-count {
		position: relative;
		margin-left: 4px;
		text-align: left;
		width: 40px;
		font-size: var(--text-small);
	}
</style>
