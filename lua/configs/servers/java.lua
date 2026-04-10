local M = {}

function M.setup(capabilities)
  -- Java
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.expand("~/.local/share/jdtls-workspace/" .. project_name)

  local java_home = os.getenv("JAVA_HOME")
  local mason = vim.fn.stdpath("data") .. "/mason"
  local lombok_jar = vim.fn.expand(mason .. "/share/jdtls/lombok.jar")

  -- Find the Equinox launcher once; abort early if not found
  local launcher =
    vim.fn.glob(mason .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher == "" then
    vim.notify("JDT LS launcher not found under Mason. Is jdtls installed?", vim.log.levels.ERROR)
  end

  vim.lsp.config("jdtls", {
    capabilities = capabilities,
    root_markers = {
      "pom.xml",
      "build.gradle",
      "build.gradle.kts",
      "settings.gradle",
      "gradlew",
      "mvnw",
      ".git",
    },

    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=false",
      "-Dlog.level=INFO",
      "-Xmx2G",
      -- The following opens were historically needed for JDK 9; not required for 21. Keep only if you actually need them.
      -- "--add-modules=ALL-SYSTEM",
      -- "--add-opens", "java.base/java.util=ALL-UNNAMED",
      -- "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-javaagent:" .. lombok_jar,
      "-jar",
      launcher,
      "-configuration",
      mason .. "/packages/jdtls/config_linux",
      "-data",
      workspace_dir,
    },

    settings = {
      java = {
        home = java_home,
        autobuild = { enabled = true },
        contentProvider = { preferred = { "fernflower" } },
        completion = {
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "org.mockito.Mockito.*",
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.springframework.boot.SpringApplication.*",
            "org.springframework.boot.autoconfigure.SpringBootApplication.*",
            "org.springframework.web.bind.annotation.*",
            "org.springframework.http.ResponseEntity.*",
          },
          filteredTypes = {
            "com.sun.*",
            "java.awt.*",
            "jdk.*",
            "sun.*",
            "org.springframework.cglib.*",
            "org.springframework.boot.loader.*",
          },
          importOrder = { "java", "javax", "com", "org", "lombok" },
        },
        referencesCodeLens = { enabled = true },
        configuration = {
          updateBuildConfiguration = "automatic",
          maven = {
            userSettings = vim.fn.expand("~/.m2/settings.xml"),
            globalSettings = "/etc/maven/settings.xml",
          },
          runtimes = {
            { name = "JavaSE-21", path = java_home, default = true },
            -- more
            -- { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
            -- { name = "JavaSE-11", path = "/usr/lib/jvm/java-11-openjdk" },
          },
        },

        -- Conform handle formatting.
        format = {
          enabled = false,
        },
        saveActions = {
          organizeImports = false,
        },

        import = {
          gradle = {
            enabled = true,
            offline = { enabled = true },
            version = "8.5",
            wrapper = { enabled = true },
          },
          maven = { enabled = true },
          -- Optionally add exclusions to avoid importing huge dirs
          -- exclusions = { "**/node_modules/**", "**/.metadata/**", "**/archetype-resources/**", "**/META-INF/maven/**" },
        },

        maven = {
          downloadSources = true,
          updateSnapshots = true,
        },

        project = {
          referencedLibraries = { "lib/**/*.jar", "./out/**/*.jar" },
        },

        sources = {
          organizeImports = {
            starThreshold = 999,
            staticStarThreshold = 999,
          },
        },
      },
    },

    on_attach = function(client)
      -- highlighting sucks
      client.server_capabilities.semanticTokensProvider = nil

      -- Disable formatting. Conform handle it.
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
  })
end

return M
