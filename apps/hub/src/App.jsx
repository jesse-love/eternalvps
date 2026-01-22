import React, { useState } from 'react';
import Header from './components/Header';
import SearchBar from './components/SearchBar';
import Footer from './components/Footer';

const allServices = [
  { name: 'COMMAND CENTER', url: 'https://chat.eternalservices.ca', description: 'Secure communications and ops coordination via Mattermost.' },
  { name: 'MISSION CONTROL', url: 'https://plane.eternalservices.ca', description: 'Project management, strategy, and roadmap via Plane.' },
  { name: 'SECURE COMMS', url: 'https://meet.eternalservices.ca', description: 'High-fidelity video conferencing via Jitsi Meet.' },
  { name: 'ENGINE ROOM', url: 'https://portainer.eternalservices.ca', description: 'Container orchestration and fleet management via Portainer.' },
  { name: 'AUTOMATION', url: 'https://n8n.eternalservices.ca', description: 'Workflow automation and integration via n8n.' },
  { name: 'ANALYTICS', url: 'https://posthog.eternalservices.ca', description: 'Product analytics and user behavior via PostHog.' },
  { name: 'WEB ANALYTICS', url: 'https://plausible.eternalservices.ca', description: 'Privacy-friendly web analytics via Plausible.' },
  { name: 'SEO', url: 'https://serpbear.eternalservices.ca', description: 'SERP tracking and SEO monitoring via SerpBear.' },
];

function App() {
  const [services, setServices] = useState(allServices);

  const handleSearch = (searchTerm) => {
    const filteredServices = allServices.filter(service =>
      service.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
    setServices(filteredServices);
  };

  return (
    <>
      <Header />
      <div className="container">
        <h1>ETERNAL SERVICES</h1>
        <p className="subtitle">Digital Sovereignty Established</p>
        <SearchBar onSearch={handleSearch} />
        <div className="grid">
          {services.map(service => (
            <a href={service.url} className="card" key={service.name}>
              <div className="glow"></div>
              <h2><span className="status-dot"></span> {service.name}</h2>
              <p>{service.description}</p>
            </a>
          ))}
        </div>
      </div>
      <Footer />
    </>
  );
}

export default App;