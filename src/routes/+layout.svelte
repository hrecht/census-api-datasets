<script>
	//import favicon from '$lib/assets/favicon.svg';
	import social from '$lib/assets/social-image-og.jpg';
	import '../styles/style.css';

	let social_description = "My page social meta description."
	let page_title = "Tracking Census Dataset Changes"

	let { children } = $props();
</script>

<svelte:head>
	<!--link rel="icon" href={favicon} /-->

	<link rel="canonical" href="https://www.hrecht.com/">

	<meta name="description" content={social_description}>
	<meta name="author" content="Hannah Recht">
	<meta name="news_keywords" content="census, data, federal government, census api, api">
	<meta property="og:title" content={page_title}>
	<meta property="og:site_name" content="Hannah Recht">
	<meta property="og:url" content="https://www.hrecht.com/">
	<meta property="og:description" content={social_description}>
	<meta property="og:type" content="article">
	<meta property="og:locale" content="en_US">
	<meta property="og:image" content={social}>
	<meta property="og:image:type" content="image/png">
	<meta property="og:image:width" content="1200">
	<meta property="og:image:height" content="628">
	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:site" content="https://www.hrecht.com/">
	<meta name="twitter:creator" content="@hannah_recht">
	<meta name="twitter:title" content={page_title}>
	<meta name="twitter:description" content={social_description}>
	<meta name="twitter:image:src" content={social}>
	<meta name="robots" content="max-image-preview:large">

	<title>{page_title}</title>
</svelte:head>

{@render children?.()}
