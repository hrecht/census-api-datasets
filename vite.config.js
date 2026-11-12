import adapter from '@sveltejs/adapter-static';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import dsv from '@rollup/plugin-dsv';

export default defineConfig({
	server: {
    cors: {
      'origin': '*',
    },
  },
	plugins: [
		sveltekit({
			paths: {
				base: process.argv.includes('dev') ? '' : process.env.BASE_PATH
			},

			adapter: adapter({
				pages: 'build',
				assets: 'build',
				fallback: undefined,
				precompress: false,
				strict: true
			})
		}),
		dsv()
	]
});
