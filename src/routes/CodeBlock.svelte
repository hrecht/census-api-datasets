<script>
	import Highlight from 'svelte-highlight';
	import r from 'svelte-highlight/languages/r';
	//import pandaSyntaxLight from 'svelte-highlight/styles/panda-syntax-light';
	import _default from 'svelte-highlight/styles/default';

	const code = `# Load the censusapi package
library(censusapi)

# Bring key metadata into a dataframe
apis <- listCensusApis()
View(apis)`;

	//let { data } = $props();
</script>

<svelte:head>
	{@html _default}
</svelte:head>

<div class="code-block">
	<Highlight language={r} {code} />
</div>

<style>
	.code-block {
		font-family: var(--font-mono);
		font-size: 1em;
		line-height: 1.8;
		padding-top: 2px;
		/*border-radius: 0.3rem;
		border: 1px solid #cccccc;
        background-color: #F3F3F3;*/
	}
</style>
