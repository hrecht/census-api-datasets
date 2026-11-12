<script>
	import {
		TableHandler,
		Datatable,
		ThSort,
		ThFilter,
		Th,
		RowCount,
		Pagination
	} from '@vincjo/datatables';
	import data from './_data/endpoints.csv';

	const table = new TableHandler(data, { rowsPerPage: 10, highlight: true });
	const { start, end, total } = $derived(table.rowCount);

	const table_vars = ['vintage', 'name', 'type', 'title'];
	const search = table.createSearch(table_vars);
</script>

<Datatable {table}>
	{#snippet header()}
		<input
			type="text"
			class="search"
			bind:value={search.value}
			oninput={() => search.set()}
			placeholder="Search..."
		/>
	{/snippet}

	<table>
		<thead>
			<tr>
				<ThSort {table} field="vintage">Vintage</ThSort>
				<ThSort {table} field="name">Name</ThSort>
				<ThSort {table} field="type">Type</ThSort>
				<ThSort {table} field="title">Title</ThSort>
			</tr>
			<tr>
				<ThFilter {table} field="vintage">Vintage</ThFilter>
				<ThFilter {table} field="name">Name</ThFilter>
				<ThFilter {table} field="type">Type</ThFilter>
				<ThFilter {table} field="title">Title</ThFilter>
			</tr>
		</thead>
		<tbody>
			{#each table.rows as row}
				<tr>
					<td>{@html row.vintage}</td>
					<td
						><a href={row.url.replace('http://', 'https://') + '.html'} target="_blank"
							>{@html row.name}</a
						></td
					>
					<td>{@html row.type}</td>
					<td>{@html row.title}</td>
				</tr>
			{/each}
		</tbody>
	</table>
	<div class="pagination-buttons">
		<button onclick={() => table.setPage('previous')}>Previous</button>
		{#each table.pagesWithEllipsis as page}
			<button
				type="button"
				class={{ active: page === table.currentPage }}
				onclick={() => table.setPage(page)}
			>
				{page ?? '...'}
			</button>
		{/each}
		<button onclick={() => table.setPage('next')}>Next</button>
	</div>
</Datatable>

<style>
	header {
		margin-bottom: 2px;
	}
	table {
		text-align: left;
		border-spacing: 0;
		border-collapse: collapse;
		width: 100%;
		margin-bottom: 1em;
		margin-top: 1em;
		overflow-x: hidden;
	}

	td {
		padding: 6x 10px !important!;
		border-bottom: 1px solid #d5d5d5 !important;
		border-right: none !important;
	}

	thead,
	th {
		font-size: var(--text-xxsmall) !important;
		font-family: var(--font-mono) !important;
		text-transform: uppercase !important;
		font-weight: 400 !important;
		padding-bottom: 0.5em !important;
	}

	.search {
		padding: 6px;
	}
	.pagination-buttons > button {
		padding: 4px 16px !important;
		border: 1px solid #cccccc !important;
		background-color: #efefef;
		color: var(--color-darkgrey);
	}

	.active {
		background-color: var(--color-highlight) !important;
		color: #ffffff !important;
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
	/*.checkbox {
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
	}*/

	/* specific styles*/

	/*.change {
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
	}*/
</style>
