const syncStatePath = '/film_log_server_state';
const syncPendingPath = '/film_log_client_pending';

Uri syncStateUri({String host = '*'}) => Uri(
  scheme: 'wear',
  host: host,
  path: syncStatePath,
);

Uri syncPendingUri({String host = '*'}) => Uri(
  scheme: 'wear',
  host: host,
  path: syncPendingPath,
);
