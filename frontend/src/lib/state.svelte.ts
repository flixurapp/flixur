import { innerWidth } from "svelte/reactivity/window";

export default new (class State {
	constructor() {}
	private _isMobile = $derived((innerWidth.current || Infinity) < 768);
	get isMobile() {
		return this._isMobile;
	}
})();
