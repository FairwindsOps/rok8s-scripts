// To see all options:
// https://vuepress.vuejs.org/config/
// https://vuepress.vuejs.org/theme/default-theme-config.html
module.exports = {
  title: "Rok8s Scripts Documentation",
  description: "Documentation for Fairwinds' rok8s-scripts",
  themeConfig: {
    docsRepo: "FairwindsOps/rok8s-scripts",
    sidebar: [
      {
        title: "Rok8s Scripts",
        path: "/",
        sidebarDepth: 0,
      },
      {
        title: "Secrets",
        path: "/secrets",
      },
      {
        title: "Versions",
        path: "/versions"
      },
      {
        title: "CircleCI Orb",
        path: "/orb",
      },
      {
        title: "Contributing",
        children: [
          {
            title: "Guide",
            path: "contributing/guide"
          },
          {
            title: "Code of Conduct",
            path: "contributing/code-of-conduct"
          }
        ]
      }
    ]
  },
}

