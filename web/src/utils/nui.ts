export async function fetchNui<T = any>(event: string, data?: unknown): Promise<T> {
  const resourceName = (window as any).GetParentResourceName
    ? (window as any).GetParentResourceName()
    : 'illenium-appearance'

  const resp = await fetch(`https://${resourceName}/${event}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data ?? {}),
  })

  return resp.json() as Promise<T>
}

export function useNuiEvent(event: string, handler: (data: any) => void) {
  const listener = (e: MessageEvent) => {
    if (e.data?.type === event) {
      handler(e.data)
    }
  }
  window.addEventListener('message', listener)
  return () => window.removeEventListener('message', listener)
}
