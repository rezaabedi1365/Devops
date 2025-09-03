import org.sonatype.nexus.repository.storage.WritePolicy

// ایجاد docker-hosted
repository.createDockerHosted(
    'docker-hosted', // name
    5001,            // https port
    null,            // http port
    true,            // v1 enabled?
    WritePolicy.ALLOW
)

// ایجاد docker-hub-proxy
repository.createDockerProxy(
    'docker-hub-proxy',
    'https://registry-1.docker.io',
    null,   // index type
    null,   // index url
    5002,   // https port
    null,   // http port
    true    // v1 enabled?
)

// ایجاد docker-group
repository.createDockerGroup(
    'docker-group',
    5003,          // https port
    null,          // http port
    true,          // v1 enabled?
    ['docker-hosted', 'docker-hub-proxy']
)
