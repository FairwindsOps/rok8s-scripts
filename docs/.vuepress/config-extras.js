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
        title: "Docker",
        path: "/docker"
      },
      {
        title: "Managing Secrets",
        path: "/secrets",
      },
      {
        title: "Deploy with Helm",
        path: "/helm"
      },
      {
        title: "Deploy Without Helm",
        path: "/without_helm"
      },
      {
        title: "CI-Images",
        path: "/ci-images"
      },
      {
        title: "CircleCI Orb",
        path: "/orb",
      },
      {
        title: "Cloud Provider Auth",
        children: [
          {
            title: "AWS",
            path: "aws"
          },
          {
            title: "GCP",
            path: "gcp"
          }
        ]
      },
      {
        title: "Versions of Rok8s Scripts",
        path: "/versions"
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

