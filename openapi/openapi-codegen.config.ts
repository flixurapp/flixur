import { defineConfig } from "@openapi-codegen/cli";
import { generateFetchers, generateSchemaTypes } from "@openapi-codegen/typescript";
export default defineConfig({
  flixur: {
    from: {
      source: "url",
      url: "http://localhost:8787/api/openapi.json",
    },
    outputDir: "api",
    to: async (context) => {
      const filenamePrefix = "flixur";
      const { schemasFiles } = await generateSchemaTypes(context, {
        filenamePrefix,
      });
      await generateFetchers(context, {
        filenamePrefix,
        schemasFiles,
      });
    },
  },
});
