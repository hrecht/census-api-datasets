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

	//let { data } = $props();
</script>

<table>
	<thead>
		<tr class="border-bottom">
			<th class="col-change" scope="col">Change</th>
			<th class="col-endpoint" scope="col">Endpoint</th>
			<th class="col-type type" scope="col">Dataset type</th>
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
	}

	td,
	th {
		padding-top: 0.8em;
		padding-bottom: 0.5em;
	}

	th {
		font-size: var(--text-xxsmall);
		text-transform: uppercase;
		font-weight: 400;
	}

	.border-bottom {
		border-bottom: 1px solid #d5d5d5;
	}

	.info {
		font-family: var(--font-mono);
	}

	/* specific styles*/
	.change {
		font-weight: 700;
		text-transform: uppercase;
	}
	.Added {
		color: var(--color-darkgreen);
	}
	.Removed {
		color: var(--color-darkred);
	}
	.type {
		text-align: right;
	}

	.title {
		font-size: var(--text-medium);
		margin-bottom: 1em;
	}
	.description {
		font-size: var(--text-small);
	}
</style>
