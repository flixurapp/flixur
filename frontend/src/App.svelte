<script lang="ts">
  import { Route, Router } from "svelte-routing";
  import Home from "./pages/home/Home.svelte";
</script>

<Router>
  <Route path="/" component={Home} />
</Router>
