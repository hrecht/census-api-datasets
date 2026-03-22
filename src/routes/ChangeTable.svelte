<script>
	import { extent, groups, rollup } from 'd3-array';
	import data from './_data/endpoint-changes.csv';

	data.forEach((d) => {
		d.change_date = new Date(d.change_date);
	});

	data.sort((b, a) => a.change_date - b.change_date);

	const changes = rollup(data, (D) => D.length, (d) => d.change);

	const changes_added = changes.get("Added");
	const changes_removed = (changes.get("Removed") === undefined) ? 0:changes.get("Removed");

	function format_date(myDate) {
		let formatted = new Intl.DateTimeFormat('en-US', {
			year: 'numeric',
			month: 'short',
			day: 'numeric'
		}).format(new Date(myDate));
		return formatted;
	}

	var tb;
	let expanded_desc = $state(false);
	let all_rows = $state(false);

	//let { data } = $props();
</script>

<p>{changes_added} dataset endpoints have been added and {changes_removed} removed since July 2025.</p>

<div class="chart">
	<h2 class="chart-title">
		{#if (changes_removed === undefined | changes_removed === 0)}
			Recently added datasets
		{:else}
			Recently added and removed datasets
		{/if}
	</h2>
	<!-- Show or hide dataset descriptions (often lengthy) in table -->
	<div class="button-group">
		<button
			class="table-button"
			type="button"
			onclick={() => {
				expanded_desc = !expanded_desc;
			}}
		>
			{#if expanded_desc}
				&#8722; Hide descriptions
			{:else}
				&#43; Show descriptions
			{/if}</button
		>
		<!--div class="checkbox">
			<div class="toggle-label-text">Show dataset descriptions</div>
			<div class="toggle-holder">
				<input
					class="toggle-input"
					id="descriptions-toggle"
					type="checkbox"
					role="switch"
					name="descriptions-toggle"
					bind:checked={expanded_desc}
				/>
				<label class="toggle-label" for="descriptions-toggle"> Toggle </label>
			</div>
		</div-->
	</div>

	<table id="tb" {expanded_desc} {all_rows}>
		<thead>
			<tr class="border-bottom">
				<th class="col-change" scope="col">Change</th>
				<th class="col-endpoint" scope="col">Endpoint</th>
				<th class="col-type" scope="col">Type</th>
			</tr>
		</thead>
		<tbody>
			{#each data as d}
				<tr>
					<td class={d.change + ' change info'}>{d.change} {format_date(d.change_date)}</td>
					<td class="endpoint info"
						><a href={d.url.replace('http://', 'https://') + '.html'} target="_blank"
							>{d.url.replace('http://api.census.gov/data/', '')}</a
						></td
					>
					<td class="type info">{d.type}</td>
				</tr>
				<tr class="border-bottom">
					<td colspan="3"
						><div class="title">{d.title}</div>
						<p class="description">{d.description}</p></td
					>
				</tr>
			{/each}
		</tbody>
	</table>

	<!-- Make toggle buttons for showing all/fewer rows IF there are many rows -->
	{#if data.length > 8}
		<div class="button-group">
			<button
				class="table-button"
				type="button"
				onclick={() => {
					all_rows = !all_rows;
				}}
			>
				{#if all_rows}
					&#8722; Show fewer rows
				{:else}
					&#43; Show all {data.length} rows
				{/if}</button
			>

			<!--div class="checkbox">
				<div class="toggle-label-text">Show all {data.length} rows</div>
				<div class="toggle-holder">
					<input
						class="toggle-input"
						id="rows-toggle"
						type="checkbox"
						role="switch"
						name="rows-toggle"
						bind:checked={all_rows}
					/>
					<label class="toggle-label" for="rows-toggle"> Toggle </label>
				</div>
			</div-->
		</div>
	{/if}

	<p class="chart-note">
		Note: Dataset titles and descriptions were written by the Census Bureau.
	</p>
</div>

<style>
	table {
		text-align: left;
		border-spacing: 0;
		border-collapse: collapse;
		width: 100%;
		margin-bottom: 1em;
		margin-top: 1em;
	}

	td {
		padding-top: 0.8em;
	}

	th {
		font-size: var(--text-xxsmall);
		font-family: var(--font-mono);
		text-transform: uppercase;
		font-weight: 400;
		padding-bottom: 0.5em;
	}

	.border-bottom {
		border-bottom: 1px solid #d5d5d5;
	}

	.table-button {
		background: none;
		color: var(--color-darkgrey);
		font-family: var(--font-mono);
		font-size: var(--text-small);
		border: none;
		cursor: pointer;
		text-align: right;
		text-decoration: underline;
		text-decoration-thickness: 1px;
		text-underline-offset: 0.15em;
		display: inline-block;
		padding: 12px 12px 12px 0px;
		margin-right: 8px;
	}

	/* toggle */
	.checkbox {
		display: inline-block;
		margin-right: 20px;
	}

	.toggle-label-text,
	.toggle-holder {
		display: inline-block;
		font-family: var(--font-mono);
		font-size: var(--text-small);
	}

	.toggle-label-text {
		margin-right: 4px;
	}

	.toggle-holder {
		vertical-align: bottom;
		padding-bottom: 2px;
	}

	.toggle-input {
		height: 0;
		width: 0;
		visibility: hidden;
	}

	.toggle-label {
		cursor: pointer;
		text-indent: -9999px;
		width: 32px;
		height: 16px;
		background: #c4c4c4;
		display: block;
		border-radius: 16px;
		position: relative;
	}

	.toggle-label:after {
		content: '';
		position: absolute;
		top: 2px;
		left: 2px;
		width: 12px;
		height: 12px;
		background: #ffffff;
		border-radius: 12px;
		transition: 0.2s;
	}

	.toggle-input:checked + .toggle-label {
		background: var(--color-highlight);
	}

	.toggle-input:checked + .toggle-label:after {
		left: calc(100% - 2px);
		transform: translateX(-100%);
	}

	.toggle-label:active:after {
		width: 12px;
	}

	/* hide dataset descriptions */
	#tb[expanded_desc='false'] > tbody > tr > td > .description {
		position: absolute;
		left: -10000px;
		top: auto;
		width: 1px;
		height: 1px;
		overflow: hidden;
	}

	/* show or hide additional rows */
	#tb[all_rows='false'] {
		tr:nth-child(n + 17) {
			display: none;
		}
	}

	#tb[all_rows='true'] {
		tr:nth-child(n + 17) {
			display: table-row;
		}
	}

	.info {
		font-family: var(--font-mono);
	}

	/* specific styles*/
	.Added {
		color: var(--color-darkgreen);
	}

	.Removed {
		color: var(--color-darkred);
	}

	.change {
		font-weight: 700;
		text-transform: uppercase;
	}

	.change,
	.col-change {
		width: 35%;
	}

	.endpoint,
	.col-endpoint {
		width: calc(65% - 110px);
	}

	.type,
	.col-type {
		text-align: right;
		width: 110px;
	}

	.title {
		font-size: var(--text-medium);
		margin-bottom: 1em;
	}

	.description {
		font-size: var(--text-small);
	}
</style>
