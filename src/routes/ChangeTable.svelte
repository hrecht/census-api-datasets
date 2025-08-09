<script>
	import data from './_data/endpoint-changes.csv';

	data.forEach((d) => {
		d.change_date = new Date(d.change_date);
	});

	data.sort((b, a) => a.change_date - b.change_date);

	function format_date(myDate) {
		let formatted = new Intl.DateTimeFormat('en-US', {
			year: 'numeric',
			month: 'short',
			day: 'numeric'
		}).format(new Date(myDate));
		return formatted;
	}
	
	var tb;
	let expanded = $state(false);

	//let { data } = $props();
</script>

<button
	class="table-expand"
	type="button"
	onclick={() => {
		tb = document.getElementById('tb');
		expanded = !expanded;
		tb.setAttribute('expanded', expanded);
	}}
>
	{#if expanded}
		&#8722; Hide descriptions
	{:else}
		&#43; Show descriptions
	{/if}</button
>

<table id="tb" expanded="false">
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
					><a href={d.url + '.html'} target="_blank"
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

	.table-expand {
		background: none;
		color: var(--color-darkgrey);
		font-family: var(--font-mono);
		border: none;
		cursor: pointer;
		text-align: right;
		text-decoration: underline;
		text-decoration-thickness: 1px;
		text-underline-offset: 0.15em;
		display: block;
	}

	#tb[expanded='false'] > tbody > tr > td > .description {
		position: absolute;
		left: -10000px;
		top: auto;
		width: 1px;
		height: 1px;
		overflow: hidden;
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
		width: 40%;
	}

	.type,
	.col-type {
		text-align: right;
		width: 25%;
	}

	.title {
		font-size: var(--text-medium);
		margin-bottom: 1em;
	}

	.description {
		font-size: var(--text-small);
	}
</style>
