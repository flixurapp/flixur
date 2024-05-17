import { getGreetingByName } from "./flixurComponents";

getGreetingByName({ pathParams: { name: "ok" } }).then((res) => {
  console.log(res);
});
