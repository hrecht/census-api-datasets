<script>
	//import favicon from '$lib/assets/favicon.svg';
	//import social from 'assets/social-image-og.png';
	import '../styles/style.css';

	const social_description = 'See when the U.S. Census Bureau adds or removes datasets.';
	const page_title = 'Tracking Census Dataset Changes';
	const canonical_url = 'https://www.hrecht.com/census-api-datasets/';
	const social_image = canonical_url + 'assets/social-image-og.png';

	let { children } = $props();
</script>

<svelte:head>
	<!--link rel="icon" href={favicon} /-->

	<link rel="canonical" href={canonical_url} />

	<meta name="description" content={social_description} />
	<meta name="author" content="Hannah Recht" />
	<meta name="news_keywords" content="census, data, federal government, census api, api" />
	<meta property="og:title" content={page_title} />
	<meta property="og:site_name" content="Hannah Recht" />
	<meta property="og:url" content={canonical_url} />
	<meta property="og:description" content={social_description} />
	<meta property="og:type" content="article" />
	<meta property="og:locale" content="en_US" />
	<meta property="og:image" content={social_image} />
	<meta property="og:image:type" content="image/png" />
	<meta property="og:image:width" content="1200" />
	<meta property="og:image:height" content="630" />
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:site" content={canonical_url} />
	<meta name="twitter:creator" content="@hannah_recht" />
	<meta name="twitter:title" content={page_title} />
	<meta name="twitter:description" content={social_description} />
	<meta name="twitter:image:src" content={social_image} />
	<meta name="robots" content="max-image-preview:large" />

	<title>{page_title}</title>
</svelte:head>

{@render children?.()}
