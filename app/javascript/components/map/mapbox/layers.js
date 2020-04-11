export const shopsLayer = data => ({
  id: 'shops',
  type: 'geojson',
  source: {
    type: 'geojson',
    promoteId: 'id',
    data,
    cluster: true,
    clusterMaxZoom: 14,
    clusterRadius: 45
  },
  render: {
    metadata: {
      position: 'top'
    },
    layers: [
      {
        id: 'shops-clusters',
        metadata: {
          position: 'top'
        },
        type: 'circle',
        filter: ['has', 'point_count'],
        paint: {
          'circle-color': '#FFF',
          'circle-stroke-width': 2,
          'circle-stroke-color': '#5ca2d1',
          'circle-radius': 12
        }
      },
      {
        id: 'shops-cluster-count',
        metadata: {
          position: 'top'
        },
        type: 'symbol',
        filter: ['has', 'point_count'],
        layout: {
          'text-allow-overlap': true,
          'text-ignore-placement': true,
          'text-field': '{point_count_abbreviated}',
          'text-size': 12
        }
      },
      {
        id: 'shops',
        metadata: {
          position: 'top'
        },
        type: 'circle',
        filter: ['!', ['has', 'point_count']],
        paint: {
          'circle-color': '#FFCC00',
          'circle-stroke-width': 1,
          'circle-stroke-color': '#333',
          'circle-radius': 10
        }
      }
    ]
  }
});
