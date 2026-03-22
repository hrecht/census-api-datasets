<script>
	/************** imports **************/
	// modules
	import { LayerCake, Svg, flatten, stack } from 'layercake';
	import { extent, groups } from 'd3-array';
	import { scaleBand, scaleOrdinal } from 'd3-scale';

	// data
	import update_time from './_data/update-time.json';
	import endpoints from './_data/endpoints.csv';

	// components
	import ChangeTable from './ChangeTable.svelte';
	import BarTable from './_components/BarTable.svelte';
	import CodeBlock from './CodeBlock.svelte';
	//import EndpointsTable from './EndpointsTable.svelte';

	// layercake components
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
</script>

<div class="container">
	<header>
		<h1>Tracking Census Dataset Changes</h1>
		<p class="update-time">Last checked for updates: {format_date(change_date)}</p>

		<div class="contact-container">
			<p>
				<a href="https://bsky.app/profile/censusapitracker.bsky.social" target="_blank">
					<svg class="contact-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16px" height="16px" aria-label="Bluesky icon"
						><path
							d="M5.769,3.618C8.291,5.512,11.004,9.352,12,11.412c0.996-2.06,3.709-5.9,6.231-7.793C20.051,2.252,23,1.195,23,4.559	c0,0.672-0.385,5.644-0.611,6.451c-0.785,2.806-3.647,3.522-6.192,3.089c4.449,0.757,5.581,3.265,3.137,5.774	c-4.643,4.764-6.672-1.195-7.193-2.722c-0.095-0.28-0.14-0.411-0.14-0.3c-0.001-0.112-0.045,0.019-0.14,0.3	c-0.521,1.527-2.55,7.486-7.193,2.722c-2.445-2.509-1.313-5.017,3.137-5.774c-2.546,0.433-5.407-0.282-6.192-3.089	C1.385,10.203,1,5.231,1,4.559C1,1.195,3.949,2.252,5.769,3.618L5.769,3.618z"
						/></svg
					><span class="contact-label">Follow updates on Bluesky</span>
				</a>
			</p>
		</div>
	</header>
	<main>

		<p>
			The <a href="https://www.census.gov/data/developers/data-sets.html" target="_blank"
				>U.S. Census Bureau APIs</a
			>
			give programmers access to {endpoints.length.toLocaleString('en-US')} different dataset endpoints.
			This page automatically checks the list of endpoints every day and tracks when datasets are added
			to or removed from the APIs. <a href="#about">Read more about this project</a>.
		</p>


		<ChangeTable />

		<p>
			The {endpoints.length.toLocaleString('en-US')} datasets in the APIs are broken down into three
			categories:
		</p>
		<ul>
			<li>
				<span class="code"
					><a
						href="https://www.census.gov/data/developers/data-sets/census-microdata-api.html"
						target="_blank">Microdata</a
					></span
				> datasets contain one record per person or housing unit for a specific vintage (time period.)
				Regular releases include person-level Current Population Survey and American Community Survey
				files. These are used for custom analyses.
			</li>
			<li>
				<span class="code">Aggregate</span> datasets are already-summarized datasets that contain
				rows with pre-computed statistics for a specific vintage (time period), usually a year.
				Popular examples include aggregate
				<a href="https://www.census.gov/data/developers/data-sets/acs-1year.html" target="_blank"
					>American Community Survey</a
				>,
				<a
					href="https://www.census.gov/data/developers/data-sets/decennial-census.html"
					target="_blank">Decennial Census</a
				>, and
				<a
					href="https://www.census.gov/data/developers/data-sets/economic-census.html"
					target="_blank">Economic Census</a
				> datasets.
			</li>
			<li>
				<span class="code">Timeseries</span> datasets are already-summarized datasets that contain
				rows with pre-computed statistics over a range of time. Some useful timeseries include
				annual
				<a href="https://api.census.gov/data/timeseries/healthins/sahie.html" target="_blank"
					>Small Area Health Insurance Estimates</a
				>
				and monthly
				<a
					href="https://api.census.gov/data/timeseries/intltrade/imports/naics.html"
					target="_blank">International Trade data</a
				>.
			</li>
		</ul>

		<div class="chart">
			<figure>
				<figcaption class="chart-title">Dataset types</figcaption>
				<BarTable
					data={type_sums}
					count_var={'datasets'}
					group_var={'type'}
					group_label={'Dataset type'}
				/>
			</figure>

			<figure>
				<figcaption class="chart-title">Dataset vintages</figcaption>
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
								ticks_wide={[1986, 1990, 2000, 2010, 2020, 2025]}
								ticks_narrow={[1986, 2005, 2025]}
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
			Several libraries make it easy to get data in your programming language of choice. The APIs
			return data in a non-standard JSON response format — I highly recommend using one of these
			wrapper libraries to access the data. Options include:
		</p>
		<ul>
			<li>
				R <span class="code"
					><a href="https://www.hrecht.com/censusapi/" target="_blank">censusapi</a></span
				>: access any dataset in the APIs as soon as it’s released
			</li>
			<li>
				R <span class="code"
					><a href="https://walker-data.com/tidycensus/" target="_blank">tidycensus</a></span
				>: access core datasets including the Decennial Census and American Community Survey with
				helper functions for analysis
			</li>
			<li>
				Python <span class="code"
					><a href="https://github.com/datamade/census" target="_blank">census</a></span
				>: access key American Community Survey and Decennial Census datasets
			</li>
			<li>
				Stata <span class="code"
					><a href="https://centeronbudget.github.io/getcensus/" target="_blank">getcensus</a></span
				>: access American Community Survey datasets
			</li>
		</ul>
		<p>
			The Census Bureau provides <a
				href="https://www.census.gov/data/developers/guidance.html"
				target="_blank">guidance and tutorials</a
			>
			focused on using their APIs directly in a web browser. You can also access some, but not all, of
			these datasets at
			<a href="https://data.census.gov/" target="_blank">data.census.gov</a>.
		</p>

		<p>
			Explore the full <a href="https://api.census.gov/data.html" target="_blank"
				>list of datasets</a
			>, or see them in <span class="code">R</span> with:
		</p>

		<CodeBlock />

		<!--div class="chart">
			<h2 class="chart-title">All datasets</h2>
			<EndpointsTable />
		</div-->
	</main>

	<footer id="about">
		<h2 class="chart-title">About this tracker</h2>
		<p>Built by <a href="https://www.hrecht.com/" target="_blank">Hannah Recht</a></p>

		<p>
			<strong>Disclaimer:</strong> This product uses the Census Bureau Data API but is not endorsed or
			certified by the Census Bureau.
		</p>

		<p>
			<strong>Why build this?</strong> The Census Bureau doesn’t maintain a public changelog or regularly
			share updates about changes to their sprawling API universe. As a longtime Census data user and
			package developer I’ve found it nearly impossible to know when data is added or removed. This project
			attempts to publicly catalog the changes.
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
			> function to grab key info about available endpoints each day using Github Actions.
		</p>
		<p>
			Datasets that are added or removed are counted as a “major change” and tracked here. The
			dataset change date reflects when the tracker script was run and thus might show a change made
			the prior day, between tracker runs. Minor changes to dataset metadata, like an updated title
			or description, are archived in the project repository but not listed here. Changes within
			existing datasets, like modified variables or geographies, are not tracked.
		</p>
		<p>
			<a href="https://github.com/hrecht/census-api-datasets" target="_blank"
				>See the code on Github.</a
			> Icons by <a href="https://icons8.com" target="_blank">Icons8</a>.
		</p>
	</footer>
</div>

<style>

	h1,
	h2,
	figcaption {
		font-family: var(--font-mono);
	}

	h2,
	figcaption {
		margin-bottom: 16px;
		margin-top: 16px;
	}

	@media only screen and (max-width: 700px) {
		h1 {
			font-size: 32px;
			margin-bottom: 4px;
		}
	}

	@media only screen and (min-width: 699px) {
		h1 {
			font-size: 36px;
			margin-bottom: 4px;
		}
	}

	.update-time {
		margin-bottom: 0.5em;
		font-size: var(--text-xsmall);
		text-transform: uppercase;
		font-family: var(--font-mono);
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
