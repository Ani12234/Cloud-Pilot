import React, { useState, useEffect } from 'react';

const shlokasData = {
  ramayana: [
    {
      sanskrit: "धर्मो हि परमो लोके धर्मे सत्यं प्रतिष्ठितम्।",
      translation: "Righteousness is supreme in the world; truth is established in righteousness.",
      source: "Valmiki Ramayana, Ayodhya Kanda"
    },
    {
      sanskrit: "उत्साहो बलवानार्य नास्त्युत्साहात्परं बलम्।",
      translation: "Enthusiasm is extremely powerful, O Noble One; there is no force greater than enthusiasm.",
      source: "Valmiki Ramayana, Kishkindha Kanda"
    },
    {
      sanskrit: "सकृदेव प्रपन्नाय तवास्मीति च याचते। अभयं सर्वभूतेभ्यो ददाम्येतद्व्रतं मम॥",
      translation: "To anyone who surrenders unto Me even once, saying 'I am Yours', I grant fearlessness from all beings. This is My eternal vow.",
      source: "Valmiki Ramayana, Yuddha Kanda"
    },
    {
      sanskrit: "जननी जन्मभूमिश्च स्वर्गादपि गरीयसी।",
      translation: "Mother and motherland are far superior even to heaven.",
      source: "Valmiki Ramayana, Yuddha Kanda"
    }
  ],
  mahabharata: [
    {
      sanskrit: "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन। मा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥",
      translation: "You have a right to perform your prescribed duty, but you are not entitled to the fruits of your actions. Never consider yourself the cause of results, and never be attached to inaction.",
      source: "Bhagavad Gita, Chapter 2, Verse 47"
    },
    {
      sanskrit: "यदा यदा हि धर्मस्य ग्लानिर्भवति भारत। अभ्युत्थानमधर्मस्य तदात्मानं सृजाम्यहम्॥",
      translation: "Whenever and wherever there is a decline in righteousness, O descendant of Bharata, and a predominant rise of unrighteousness—at that time I descend Myself.",
      source: "Bhagavad Gita, Chapter 4, Verse 7"
    },
    {
      sanskrit: "यतो धर्मस्ततो जयः।",
      translation: "Where there is Dharma (Righteousness), there is Victory (Jaya).",
      source: "Mahabharata, Sanskrit Proverb"
    },
    {
      sanskrit: "न हि वैरेण वैराणि शाम्यन्तीह कदाचन। अवैरेण च शाम्यन्ति एष धर्मः सनातनः॥",
      translation: "Hatred is never appeased by hatred in this world. By non-hatred alone is hatred appeased. This is the law eternal.",
      source: "Mahabharata, Udyoga Parva"
    }
  ]
};

const charactersData = {
  ramayana: [
    {
      role: "Incarnation of Vishnu",
      name: "Sri Rama",
      bio: "The prince of Ayodhya and the embodiment of righteousness (Maryada Purushottama). He strictly adheres to duty and moral law (Dharma) despite facing severe personal hardships, including a 14-year exile."
    },
    {
      role: "Incarnation of Lakshmi",
      name: "Devi Sita",
      bio: "The princess of Mithila and wife of Sri Rama. Known for her purity, immense resilience, and devotion. Her strength shines through during her captivity in Lanka and subsequent trials."
    },
    {
      role: "Divine Devotee",
      name: "Lord Hanuman",
      bio: "A vanara of exceptional power, wisdom, and speech. His selfless devotion to Rama and Sita is unparalleled. He leaps across the ocean to find Sita and carries a mountain of healing herbs to save Lakshmana."
    },
    {
      role: "Demon King",
      name: "Ravana",
      bio: "The ten-headed king of Lanka. He was a brilliant scholar, master musician, and devotee of Shiva, but his immense ego, hubris, and lust led to his downfall when he abducted Sita."
    }
  ],
  mahabharata: [
    {
      role: "Divine Charioteer",
      name: "Lord Krishna",
      bio: "The king of Dwarka and eighth avatar of Vishnu. He plays the role of diplomat, strategist, and philosophical guide to the Pandavas. He speaks the Bhagavad Gita to Arjuna on the battlefield of Kurukshetra."
    },
    {
      role: "Heroic Archer",
      name: "Arjuna",
      bio: "The third Pandava prince, regarded as the greatest archer of his time. Faced with fighting his own family, he undergoes a moral crisis, leading to Krishna's exposition of duty and cosmic order (the Gita)."
    },
    {
      role: "Tragic Legend",
      name: "Karna",
      bio: "The eldest son of Kunti, born of the Sun god but raised by a charioteer. Known for his legendary generosity and archery skills. Bound by friendship and loyalty to Duryodhana, he tragically fights against his brothers."
    },
    {
      role: "Fiery Empress",
      name: "Draupadi",
      bio: "The princess of Panchala and wife of the five Pandavas. Born from a sacred fire altar, she is a strong-willed empress whose humiliation in the Kuru assembly hall becomes the catalyst for the Kurukshetra War."
    }
  ]
};

const timelinesData = {
  ramayana: [
    {
      chapter: "Bala Kanda",
      title: "The Golden Beginnings",
      desc: "Chronicles the birth and education of Rama and his brothers, Rama's protection of sage Vishvamitra's sacrifices, the breaking of Shiva's mighty bow in Mithila, and his marriage to Sita."
    },
    {
      chapter: "Ayodhya Kanda",
      title: "The Test of Duty",
      desc: "Details the preparations for Rama's coronation, Queen Kaikeyi's manipulation demanding Rama's 14-year exile, Rama's calm acceptance of his father's vow, and the departure of Rama, Sita, and Lakshmana."
    },
    {
      chapter: "Aranya Kanda",
      title: "The Shadows of the Forest",
      desc: "Describes the trio's life in the Dandakaranya forest, encounters with demons, the cutting of Shurpanakha's nose, and the abduction of Sita by Ravana using a golden deer trick."
    },
    {
      chapter: "Sundara Kanda",
      title: "The Book of Beauty & Hope",
      desc: "Focuses entirely on Hanuman's heroic deeds: his flight to Lanka, locating Sita in the Ashoka grove, presenting Rama's ring, burning Lanka, and returning with news of her safety."
    },
    {
      chapter: "Yuddha Kanda",
      title: "The Ultimate Triumph",
      desc: "Depicts the construction of the Rama Setu bridge across the ocean, the siege of Lanka, the fierce battles, Rama's slaying of Ravana, Sita's rescue, and their return to Ayodhya for coronation."
    }
  ],
  mahabharata: [
    {
      chapter: "Adi Parva",
      title: "The Roots of Conflict",
      desc: "Details the origins of the Kuru dynasty, the birth and training of the Pandavas and Kauravas, the jealousy of Duryodhana, and the Pandavas' marriage to Draupadi."
    },
    {
      chapter: "Sabha Parva",
      title: "The Hall of Illusions",
      desc: "Chronicles Yudhishthira's rise, the construction of the magical assembly hall, the fateful game of dice engineered by Shakuni, the humiliation of Draupadi, and the Pandavas' 13-year exile."
    },
    {
      chapter: "Vana Parva",
      title: "The Wisdom of Exile",
      desc: "Spans the 12 years spent by the Pandavas in the forest. Arjuna travels to get celestial weapons from Shiva, and the brothers learn spiritual lessons from wandering sages."
    },
    {
      chapter: "Bhishma Parva",
      title: "The Song of the Lord",
      desc: "Covers the start of the Kurukshetra War. It contains the Bhagavad Gita, spoken by Lord Krishna to a despondent Arjuna, outlining the paths of Karma, Bhakti, and Jnana."
    },
    {
      chapter: "Svargarohana Parva",
      title: "The Final Ascent",
      desc: "Describes the Pandavas' final retirement and their pilgrimage to the Himalayas. Yudhishthira is tested at the gates of heaven, proving the ultimate victory of unconditional Dharma."
    }
  ]
};

export default function App() {
  const [activeEpic, setActiveEpic] = useState('ramayana');
  const [shlokaIndex, setShlokaIndex] = useState(0);

  // Sync body theme class with state
  useEffect(() => {
    document.body.className = activeEpic === 'ramayana' ? 'theme-ramayana' : 'theme-mahabharata';
  }, [activeEpic]);

  // Switch epics
  const handleEpicSwitch = (epic) => {
    setActiveEpic(epic);
    setShlokaIndex(0); // Reset shloka index
  };

  // Select next shloka
  const getNextShloka = () => {
    const list = shlokasData[activeEpic];
    setShlokaIndex((prevIndex) => (prevIndex + 1) % list.length);
  };

  const activeShloka = shlokasData[activeEpic][shlokaIndex];

  return (
    <div className="app-container">
      <header>
        <h1 className="app-title">Itihasa Chronicles</h1>
        <p className="app-subtitle">Explore the ancient epics and timeless wisdom of Ramayana & Mahabharata</p>
      </header>

      {/* Epic Switcher Tabs */}
      <div className="selector-container">
        <div className="epic-selector">
          <button 
            className={`selector-btn ${activeEpic === 'ramayana' ? 'active' : ''}`}
            onClick={() => handleEpicSwitch('ramayana')}
          >
            Ramayana
          </button>
          <button 
            className={`selector-btn ${activeEpic === 'mahabharata' ? 'active' : ''}`}
            onClick={() => handleEpicSwitch('mahabharata')}
          >
            Mahabharata
          </button>
        </div>
      </div>

      {/* Hero Wisdom Card */}
      <div className="hero-card">
        <span className="epic-badge">
          {activeEpic === 'ramayana' ? 'Valmiki’s Masterpiece' : 'Vyasa’s Great Saga'}
        </span>
        <h2 className="hero-title">
          {activeEpic === 'ramayana' 
            ? 'The Journey of Righteousness (Dharma)' 
            : 'The Battle of Duty & Destiny'}
        </h2>
        <p className="hero-description">
          {activeEpic === 'ramayana' 
            ? 'The Ramayana tells the story of Sri Rama, the seventh avatar of Vishnu, whose life serves as a guide to perfect morality, familial duties, and ideal leadership.'
            : 'The Mahabharata is the longest epic poem ever written, detailing the conflict between two factions of Kurus (Pandavas and Kauravas) and containing the philosophical core of the Bhagavad Gita.'}
        </p>

        {/* Interactive Quote Box */}
        <div className="shloka-box">
          <p className="shloka-sanskrit">{activeShloka.sanskrit}</p>
          <p className="shloka-translation">“{activeShloka.translation}”</p>
          <span className="shloka-source">— {activeShloka.source}</span>
        </div>
        <button className="wisdom-btn" onClick={getNextShloka}>
          Receive Next Wisdom
        </button>
      </div>

      {/* Characters Section */}
      <section className="characters-section">
        <h2 className="section-title">Key Pillars of the Epic</h2>
        <div className="characters-grid">
          {charactersData[activeEpic].map((char, index) => (
            <div className="character-card" key={index}>
              <span className="char-role">{char.role}</span>
              <h3 className="char-name">{char.name}</h3>
              <p className="char-bio">{char.bio}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Timeline Section */}
      <section className="timeline-section">
        <h2 className="section-title">Chronological Narrative (Chapters)</h2>
        <div className="timeline-container">
          {timelinesData[activeEpic].map((item, index) => (
            <div className="timeline-item" key={index}>
              <div className="timeline-dot"></div>
              <div className="timeline-content">
                <span className="timeline-chapter">{item.chapter}</span>
                <h3 className="timeline-title">{item.title}</h3>
                <p className="timeline-desc">{item.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      <footer>
        <p>Built with ❤️ and React | Running on a lightweight Kubernetes cluster (k3s)</p>
        <p>Managed via GitHub Actions CI/CD | Supervised by <a href="https://github.com/Ani12234/terraforge" target="_blank" rel="noopener noreferrer">TerraForge Pipeline</a></p>
      </footer>
    </div>
  );
}
