<script>
	/************** imports **************/
	// modules
	import { LayerCake, Svg, flatten, stack } from 'layercake';
	import { scaleBand, scaleOrdinal, groups, extent } from 'd3';

	// data
	import update_time from './_data/update-time.json';
	import endpoints from './_data/endpoints.csv';

	// components
	import ChangeTable from './ChangeTable.svelte';
	import BarTable from './_components/BarTable.svelte';

	// layercake components
	//import Bar from './_components/Bar.svelte';
	//import Column from './_components/Column.svelte';
	import ColumnStacked from './_components/ColumnStacked.svelte';
	import AxisX from './_components/AxisX.svelte';
	import AxisY from './_components/AxisY.svelte';

	/************* prep data **************/
	// last checked for updates
	const change_date = new Date(update_time.updated);

	function format_date(myDate) {
		let formatted = new Intl.DateTimeFormat('en-US', {
			year: 'numeric',
			month: 'short',
			day: 'numeric'
		}).format(new Date(myDate));
		return formatted;
	}

	endpoints.forEach((d) => {
		d.vintage = +d.vintage;
	});

	// count endpoints by type for bartable
	const type_sums = groups(endpoints, (d) => d.type).map((k) => {
		return {
			type: k[0],
			datasets: k[1].length
		};
	});

	// count endpoints by vintage and type for stacking
	const stack_types = ['Aggregate', 'Microdata'];
	const type_colors = ['#0d565c', '#329da7'];

	var typed = Object.groupBy(
		endpoints.filter((d) => {
			return d.vintage != 0;
		}),
		(d) => d.vintage
	);

	const grouped = Object.entries(typed).map(([vintage, groups]) => {
		// for each type, create an array of [type, count of type];
		var counts = [...stack_types].map((c) => [c, groups.filter((g) => g.type == c).length]);
		// use Object.forEntries to merge this in
		var summed = {
			vintage,
			...Object.fromEntries(counts)
		};
		return summed;
	});

	grouped.forEach((d) => {
		d.vintage = +d.vintage;
	});

	// for stacked data, make sure all years between domain min and max are used in xDomain, even if not in data
	const x_extent = extent(grouped, function (d) {
		return d.vintage;
	});

	// fill in any missing years to pass to xDomain
	const years = Array.from(
		{
			length: x_extent[1] - x_extent[0] + 1
		},
		(v, k) => k + x_extent[0]
	);

	const stacked_data = stack(grouped, stack_types);

	/*const vintage_sums = d3
		.groups(endpoints, (d) => d.vintage)
		.map((k) => {
			return {
				vintage: k[0],
				datasets: k[1].length
			};
		})
		.filter((d) => {
			return d.vintage != 0;
		});*/
</script>

<div class="container">
	<div class="copy-width">
		<h1>Tracking Census Dataset Changes</h1>

		<p>
			The <a href="https://www.census.gov/data/developers/data-sets.html" target="_blank"
				>U.S. Census Bureau APIs</a
			>
			give programmers access to {endpoints.length.toLocaleString('en-US')} different dataset endpoints.
			This page automatically checks the list of endpoints every day and tracks when datasets are added
			to or removed from the APIs.
		</p>
		<p><a href="#about">Read more about this project</a>.</p>

		<div class="chart">
			<h2 class="chart-title">Recently added and removed datasets</h2>
			<div class="update-time">Last checked for updates: {format_date(change_date)}</div>

			<ChangeTable />
			<p class="chart-note">
				Note: Dataset titles and descriptions were written by the Census Bureau.
			</p>
		</div>

		<p>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
			labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
			laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
			voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
		</p>

		<div class="chart">
			<figure>
				<h2 class="chart-title">Dataset types</h2>
				<BarTable
					data={type_sums}
					count_var={'datasets'}
					group_var={'type'}
					group_label={'Dataset type'}
				/>
			</figure>

			<figure>
				<h2 class="chart-title">Dataset vintages</h2>
				<div class="chart-container">
					<LayerCake
						padding={{ top: 5, right: 5, bottom: 20, left: 30 }}
						x={(d) => d.data['vintage']}
						y={[0, 1]}
						z={'key'}
						xScale={scaleBand().paddingInner(0.1).round(true)}
						xDomain={years}
						zScale={scaleOrdinal()}
						zDomain={stack_types}
						zRange={type_colors}
						flatData={flatten(stacked_data)}
						data={stacked_data}
					>
						<Svg
							label="Chart showing the number of datasets by vintage year, from 1986 to 2025 peaking in 2012 and 2017 with more than 120 each."
						>
							<AxisY ticks={[0, 40, 80, 120]} snapBaselineLabel />
							<AxisX
								baseline={true}
								gridlines={false}
								ticks={[1986, 1990, 2000, 2010, 2020, 2025]}
								tickMarks={true}
							/>
							<ColumnStacked />
						</Svg>
					</LayerCake>
				</div>
			</figure>
		</div>

		<h2>How to use the APIs</h2>
		<p>
			Several libraries make it easy to get data in your programming language of choice. The
			APIs return data in a non-standard JSON response format — I highly recommend using one of
			these wrapper libraries to access the data. Options include:
		</p>
		<ul>
			<li>
				R: <span class="code"
					><a href="https://www.hrecht.com/censusapi/" target="_blank">censusapi</a></span
				> provides access to any dataset in the APIs as soon as it’s released
			</li>
			<li>
				R: <span class="code"
					><a href="https://walker-data.com/tidycensus/" target="_blank">tidycensus</a></span
				> provides access to core datasets including the Decennial Census and American Community Survey
				with nice helper functions for analysis
			</li>
			<li>
				Python: <span class="code"
					><a href="https://github.com/datamade/census" target="_blank">census</a></span
				> provides access to key American Community Survey and Decennial Census datasets
			</li>
			<li>
				Stata: <span class="code"
					><a href="https://centeronbudget.github.io/getcensus/" target="_blank">getcensus</a></span
				> provides access to American Community Survey datasets
			</li>
		</ul>
		<p>
			The Census Bureau provides <a
				href="https://www.census.gov/data/developers/guidance.html"
				target="_blank">guidance and tutorials</a
			> focused on accessing their APIs directly in the browser. You can also access some, but not all, of the API datasets at <a href="https://data.census.gov/" target="_blank">data.census.gov</a>.
		</p>

		<!-- <figure class="flex-child">
				<h2 class="chart-title">Dataset vintages</h2>
				<div id="vintage-chart" class="chart-container">
					<LayerCake
						padding={{ top: 5, right: 5, bottom: 20, left: 30 }}
						x={'vintage'}
						y={'datasets'}
						xScale={scaleBand().paddingInner(0.1).round(true)}
						xDomain={years}
						yDomain={[0, null]}
						data={vintage_sums}
					>
						<Svg label="A chart label of some kind.">
							<AxisY ticks={[0, 40, 80, 120]} snapBaselineLabel />
							<AxisX
								baseline={true}
								gridlines={false}
								ticks={[1986, 1990, 2000, 2010, 2020, 2025]}
								tickMarks={true}
							/>
							<Column showLabels={false} />
						</Svg>
					</LayerCake>
				</div>
			</figure> -->

		<section id="about">
			<h2 class="chart-title">About this tracker</h2>
			<p>Built by <a href="https://www.hrecht.com/" target="_blank">Hannah Recht</a></p>

			<p>
				<strong>Disclaimer:</strong> This product uses the Census Bureau Data API but is not endorsed
				or certified by the Census Bureau.
			</p>

			<p>
				<strong>Why build this?</strong> The Census Bureau doesn’t maintain a public changelog or regularly
				share updates about changes to their sprawling API universe. As a longtime Census data user and
				package developer I’ve found it nearly impossible to know when data is added or removed. This
				project attempts to publicly catalog the changes.
			</p>
			<p>
				This tracker uses the R <span class="code">
					<a href="https://www.hrecht.com/censusapi/" target="_blank">censusapi</a>
				</span>
				package
				<span class="code"
					><a href="https://www.hrecht.com/censusapi/reference/listCensusApis.html" target="_blank"
						>listCensusApis()</a
					></span
				> function to grab key info about available endpoints each day using Github actions. This page
				is built with Svelte.
			</p>
			<p>
				Datasets that are added or removed are counted as a “major change” and tracked here. The
				dataset change date reflects when the tracker script was run and thus might show a change
				made the prior day, between tracker runs. Minor changes to dataset metadata, like an updated
				title or description, are archived in the project repository but not listed here. Changes
				within existing datasets, like modified variables or geographies, are not tracked.
			</p>
			<p>
				<a href="https://github.com/hrecht/census-api-datasets" target="_blank"
					>See the code on Github.</a
				>
			</p>
		</section>
	</div>
</div>

<style>
	.chart {
		padding-bottom: 20px;
		padding-top: 20px;
	}

	.chart-container {
		width: 100%;
		height: 300px;
		overflow-x: hidden;
	}

	h1,
	h2 {
		font-family: var(--font-mono);
	}

	.update-time {
		padding-bottom: 1em;
	}
	#about {
		padding: 40px;
		border: 1px solid var(--color-highlight);
	}
	#about > p {
		font-size: var(--text-small);
	}
	.code {
		font-family: var(--font-mono);
		background-color: #efefef;
		font-size: 0.9em;
		padding: 2px 2px 4px 2px;
	}
	/*
	.flex {
		display: flex;
		flex-wrap: wrap;
		justify-content: space-between;
	}

	@media only screen and (max-width: 700px) {
		.flex-child {
			flex: 0 0 100%;
		}
	}

	@media only screen and (min-width: 699px) {
		.flex-child {
			flex: 0 1 calc(50% - 15px);
		}
	}
	*/
</style>
